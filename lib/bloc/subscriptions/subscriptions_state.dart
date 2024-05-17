part of 'subscriptions_bloc.dart';

enum SubscriptionStatus { subscribed, unsubscribed }

class SubscriptionsState extends Equatable {
  final SubscriptionStatus subscriptionStatus;
  final Offerings? availableProducts;
  const SubscriptionsState(
      {required this.availableProducts, required this.subscriptionStatus});

  SubscriptionsState copyWith({
    Offerings? availableProducts,
    SubscriptionStatus? subscriptionStatus,
  }) {
    return SubscriptionsState(
      availableProducts: availableProducts ?? this.availableProducts,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
    );
  }

  @override
  List<Object?> get props => [availableProducts, subscriptionStatus];
}
