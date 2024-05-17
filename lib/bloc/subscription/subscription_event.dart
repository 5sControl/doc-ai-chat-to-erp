// part of 'subscription_bloc.dart';
//
// abstract class SubscriptionEvent extends Equatable {
//   const SubscriptionEvent();
// }
//
//
//
// class BuySubscription extends SubscriptionEvent {
//   final String subscriptionId;
//   const BuySubscription({required this.subscriptionId});
//
//   @override
//   List<Object?> get props => [subscriptionId];
// }
//
// class Start extends SubscriptionEvent {
//   const Start();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class PaymentComplete extends SubscriptionEvent {
//   final String productId;
//   const PaymentComplete({required this.productId});
//
//   @override
//   List<Object?> get props => [productId];
// }
//
// class OnShowSubscriptionComplete extends SubscriptionEvent {
//   const OnShowSubscriptionComplete();
//
//   @override
//   List<Object?> get props => [];
// }