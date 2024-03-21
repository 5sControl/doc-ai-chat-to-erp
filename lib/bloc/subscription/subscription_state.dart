part of 'subscription_bloc.dart';

enum SubscriptionsStatus { subscribed, unsubscribed }

@JsonSerializable()
class SubscriptionState extends Equatable {
  final SubscriptionsStatus subscriptionsStatus;

  final List<StoreProduct> availableProducts;
  const SubscriptionState(
      {required this.subscriptionsStatus, required this.availableProducts});

  SubscriptionState copyWith({
    SubscriptionsStatus? subscriptionsStatus,
    List<StoreProduct>? availableProducts,
  }) {
    return SubscriptionState(
        subscriptionsStatus: subscriptionsStatus ?? this.subscriptionsStatus,
        availableProducts: availableProducts ?? this.availableProducts);
  }

  @override
  List<Object> get props => [subscriptionsStatus, availableProducts];

  factory SubscriptionState.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStateFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionStateToJson(this);
}
