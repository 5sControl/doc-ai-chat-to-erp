// import 'dart:async';
// import 'dart:io';
//
// import 'package:bloc_concurrency/bloc_concurrency.dart';
// import 'package:equatable/equatable.dart';
// import 'package:facebook_app_events/facebook_app_events.dart';
// import 'package:hydrated_bloc/hydrated_bloc.dart';
// import 'package:json_annotation/json_annotation.dart';
//
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
// import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
// import 'package:stream_transform/stream_transform.dart';
// import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
// import 'package:summify/models/models.dart';
//
// part 'subscription_event.dart';
// part 'subscription_state.dart';
// part 'subscription_bloc.g.dart';
//
// const throttleDuration = Duration(milliseconds: 200);
//
// EventTransformer<E> throttleDroppable<E>(Duration duration) {
//   return (events, mapper) {
//     return concurrent<E>().call(events.throttle(duration), mapper);
//   };
// }
//
// class SubscriptionBloc
//     extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   final MixpanelBloc mixpanelBloc;
//
//   Set<String> appleProductIds = {
//     "SummifyPremiumWeekly",
//     'SummifyPremiumMonth',
//     'SummifyPremiumYear'
//   };
//
//   Set<String> googleProductIds = {
//     "summify_premium_week",
//     'summify_premium_month',
//     'summify_premium_year'
//   };
//
//   List<ProductDetails> _products = [];
//
//   SubscriptionBloc(
//       {required this.mixpanelBloc})
//       : super(const SubscriptionState(
//             subscriptionsStatus: SubscriptionsStatus.unsubscribed,
//             availableProducts: [],
//             transactionStatus: TransactionStatus.idle)) {
//     StreamSubscription<List<PurchaseDetails>>? subscription;
//
//     Future<void> initStoreInfo() async {
//       final bool isAvailable = await _inAppPurchase.isAvailable();
//       if (!isAvailable) {
//         _products = [];
//         return;
//       }
//
//       if (Platform.isIOS) {
//         var iosPlatformAddition = _inAppPurchase
//             .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
//         await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
//       }
//
//       ProductDetailsResponse productDetailResponse =
//           await _inAppPurchase.queryProductDetails(
//               Platform.isIOS ? appleProductIds : googleProductIds);
//       if (productDetailResponse.error != null) {
//         // _products = productDetailResponse.productDetails;
//         return;
//       }
//
//       if (productDetailResponse.productDetails.isEmpty) {
//         // _products = productDetailResponse.productDetails;
//         return;
//       }
//
//       _products = productDetailResponse.productDetails;
//       final List<StoreProduct> products = [];
//
//       _products.forEach((product) {
//         products.add(StoreProduct(
//             id: product.id,
//             currencySymbol: product.currencySymbol,
//             title: product.title,
//             description: product.description,
//             price: product.price,
//             rawPrice: product.rawPrice,
//             currencyCode: product.currencyCode));
//       });
//
//       emit(state.copyWith(availableProducts: products));
//     }
//
//     void _onStarted(event, Emitter emit) {
//       final Stream<List<PurchaseDetails>> purchaseUpdated =
//           _inAppPurchase.purchaseStream;
//       subscription = purchaseUpdated.listen((purchaseDetailsList) {
//         purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//           switch (purchaseDetails.status) {
//             case PurchaseStatus.pending:
//               {
//                 // print('pending');
//               }
//             case PurchaseStatus.purchased:
//               {
//                 // print('purchased');
//                 add(PaymentComplete(productId: purchaseDetails.productID));
//               }
//             case PurchaseStatus.error:
//               {
//                 // print('error');
//               }
//             case PurchaseStatus.restored:
//               {
//                 // print('restored');
//                 add(PaymentComplete(productId: purchaseDetails.productID));
//               }
//
//             case PurchaseStatus.canceled:
//               {
//                 // print('canceled');
//               }
//           }
//         });
//       }, onDone: () {
//         subscription?.cancel();
//       }, onError: (error) {
//         // handle error.
//       });
//
//       initStoreInfo();
//     }
//
//     Future<void> _buyProduct(BuySubscription event, Emitter emit) async {
//       if (Platform.isIOS) {
//         var paymentWrapper = SKPaymentQueueWrapper();
//         var transactions = await paymentWrapper.transactions();
//         transactions.forEach((transaction) async {
//           await paymentWrapper.finishTransaction(transaction);
//         });
//       }
//       final PurchaseParam purchaseParam = PurchaseParam(
//           productDetails: _products
//               .firstWhere((product) => product.id == event.subscriptionId));
//       await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//     }
//
//     @override
//     Future<void> close() {
//       subscription?.cancel();
//       return super.close();
//     }
//
//     on<BuySubscription>(_buyProduct);
//
//     on<Start>(_onStarted);
//
//     on<PaymentComplete>(
//       (event, emit) async {
//         mixpanelBloc.add(ActivateSubscription(plan: event.productId));
//         emit(
//           state.copyWith(
//               subscriptionsStatus: SubscriptionsStatus.subscribed,
//               transactionStatus: TransactionStatus.complete),
//         );
//         add(OnShowSubscriptionComplete());
//       },
//       transformer: throttleDroppable(throttleDuration),
//     );
//
//     on<OnShowSubscriptionComplete>(
//       (event, emit) async {
//         emit(
//           state.copyWith(transactionStatus: TransactionStatus.idle),
//         );
//       },
//     );
//   }
//
//   @override
//   SubscriptionState? fromJson(Map<String, dynamic> json) {
//     return SubscriptionState.fromJson(json);
//   }
//
//   @override
//   Map<String, dynamic>? toJson(SubscriptionState state) {
//     return state.toJson();
//   }
// }
//
// class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
//   @override
//   bool shouldContinueTransaction(
//       SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
//     return true;
//   }
//
//   @override
//   bool shouldShowPriceConsent() {
//     return false;
//   }
// }
