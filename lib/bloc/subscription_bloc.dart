import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';
part 'subscription_bloc.g.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  static const bool _started = false;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  Set<String> _kProductIds = {"Weekly_Subscription"};
  List<ProductDetails> _products = [];

  SubscriptionBloc() : super(const SubscriptionState(isSubscribed: false)) {
    StreamSubscription<List<PurchaseDetails>>? _subscription;

    Future<void> initStoreInfo() async {
      final bool isAvailable = await _inAppPurchase.isAvailable();

      if (!isAvailable) {
        _products = [];
        return;
      }

      if (Platform.isIOS) {
        var iosPlatformAddition = _inAppPurchase
            .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
      }

      ProductDetailsResponse productDetailResponse =
          await _inAppPurchase.queryProductDetails(_kProductIds);

      if (productDetailResponse.error != null) {
        _products = productDetailResponse.productDetails;
        return;
      }

      if (productDetailResponse.productDetails.isEmpty) {
        _products = productDetailResponse.productDetails;
        return;
      }

      _products = productDetailResponse.productDetails;
      print(_products.first.id);
    }

    void _onStarted(event, Emitter emit) {
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;
        print('asdasdasdasd');
      _subscription = purchaseUpdated.listen((purchaseDetailsList) {
        purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
          if (purchaseDetails.status == PurchaseStatus.pending) {
            // emit(PaymentPending());
            print('pending');
          } else {
            if (purchaseDetails.status == PurchaseStatus.error) {
              // emit(PaymentError());
              print('error');
            } else if (purchaseDetails.pendingCompletePurchase) {
              await _inAppPurchase.completePurchase(purchaseDetails);
              // emit(PaymentComplete());
              print('complete');
            }
          }
        });
      }, onDone: () {
        _subscription?.cancel();
      }, onError: (error) {
        // handle error.
      });

      initStoreInfo();
    }

    Future<void> _buyProduct(BuySubscription event, Emitter emit) async {
      var paymentWrapper = SKPaymentQueueWrapper();
      var transactions = await paymentWrapper.transactions();
      transactions.forEach((transaction) async {
        await paymentWrapper.finishTransaction(transaction);
      });
      final PurchaseParam purchaseParam = PurchaseParam(
          productDetails:
              _products.firstWhere((product) => product.id == event.subscriptionId));
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }

    @override
    Future<void> close() {
      _subscription?.cancel();
      return super.close();
    }

    // on<SetIsSubscribed>((event, emit) {
    //   print('Subscribed');
    //   emit(state.copyWith(isSubscribed: event.isSubscribed));
    // });
    on<BuySubscription>(_buyProduct);

    on<Start>(_onStarted);
  }

  @override
  SubscriptionState? fromJson(Map<String, dynamic> json) {
    return SubscriptionState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(SubscriptionState state) {
    return state.toJson();
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
