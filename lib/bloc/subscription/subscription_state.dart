part of 'subscription_bloc.dart';

enum SubscriptionsStatus { subscribed, unsubscribed }
enum TransactionStatus {idle, pending, complete, error, canceled }

@JsonSerializable()
class SubscriptionState extends Equatable {
  final SubscriptionsStatus subscriptionsStatus;
  final TransactionStatus transactionStatus;
  final List<StoreProduct> availableProducts;
  const SubscriptionState(
      {required this.subscriptionsStatus, required this.availableProducts, required this.transactionStatus});

  SubscriptionState copyWith({
    SubscriptionsStatus? subscriptionsStatus,
    List<StoreProduct>? availableProducts,
    TransactionStatus? transactionStatus,
  }) {
    return SubscriptionState(
        transactionStatus: transactionStatus ?? this.transactionStatus,
        subscriptionsStatus: subscriptionsStatus ?? this.subscriptionsStatus,
        availableProducts: availableProducts ?? this.availableProducts);
  }

  @override
  List<Object> get props => [subscriptionsStatus, availableProducts, transactionStatus];

  factory SubscriptionState.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStateFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionStateToJson(this);
}
