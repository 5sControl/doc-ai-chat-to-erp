part of 'subscription_bloc.dart';

abstract class SubscriptionEvent extends Equatable {
  const SubscriptionEvent();
}

class SetIsSubscribed extends SubscriptionEvent {
  final bool isSubscribed;
  const SetIsSubscribed({required this.isSubscribed});

  @override
  List<Object?> get props => [];
}

class BuySubscription extends SubscriptionEvent {
  final String subscriptionId;
  const BuySubscription({required this.subscriptionId});

  @override
  List<Object?> get props => [subscriptionId];
}

class Start extends SubscriptionEvent {
  const Start();

  @override
  List<Object?> get props => [];
}
