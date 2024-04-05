import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/models/models.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';
part 'subscription_bloc.g.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final MixpanelBloc mixpanelBloc;
  Set<String> kProductIds = {
    "SummifyPremiumWeekly",
    'SummifyPremiumMonth',
    'SummifyPremiumYear'
  };
  List<ProductDetails> _products = [];

  SubscriptionBloc({required this.mixpanelBloc})
      : super(const SubscriptionState(
            subscriptionsStatus: SubscriptionsStatus.unsubscribed,
            availableProducts: [])) {
    StreamSubscription<List<PurchaseDetails>>? subscription;

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
          await _inAppPurchase.queryProductDetails(kProductIds);

      if (productDetailResponse.error != null) {
        // _products = productDetailResponse.productDetails;
        return;
      }

      if (productDetailResponse.productDetails.isEmpty) {
        // _products = productDetailResponse.productDetails;
        return;
      }

      _products = productDetailResponse.productDetails;
      final List<StoreProduct> products = [];

      _products.forEach((product) {
        products.add(StoreProduct(
            id: product.id,
            currencySymbol: product.currencySymbol,
            title: product.title,
            description: product.description,
            price: product.price,
            rawPrice: product.rawPrice,
            currencyCode: product.currencyCode));
      });

      emit(state.copyWith(availableProducts: products));
    }

    void _onStarted(event, Emitter emit) {
      final Stream<List<PurchaseDetails>> purchaseUpdated =
          _inAppPurchase.purchaseStream;
      subscription = purchaseUpdated.listen((purchaseDetailsList) {
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

              if (purchaseDetails.status == PurchaseStatus.restored ||
                  purchaseDetails.status == PurchaseStatus.purchased) {
                print('complete');
                add(const PaymentComplete());

                var plan = '';
                switch (purchaseDetails.productID) {
                  case 'SummifyPremiumYear':
                    plan = 'year';
                  case 'SummifyPremiumMonth':
                    plan = 'month';
                  case 'SummifyPremiumWeekly':
                    plan = 'week';
                }

                mixpanelBloc.add(ActivateSubscription(plan: plan));
              }
            }
          }
        });
      }, onDone: () {
        subscription?.cancel();
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
          productDetails: _products
              .firstWhere((product) => product.id == event.subscriptionId));
      await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }

    @override
    Future<void> close() {
      subscription?.cancel();
      return super.close();
    }

    on<BuySubscription>(_buyProduct);

    on<Start>(_onStarted);

    on<PaymentComplete>(
      (event, emit) async {
        emit(
          state.copyWith(subscriptionsStatus: SubscriptionsStatus.subscribed),
        );
      },
    );
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
