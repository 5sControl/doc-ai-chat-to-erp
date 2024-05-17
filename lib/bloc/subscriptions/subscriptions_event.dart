part of 'subscriptions_bloc.dart';

abstract class SubscriptionsEvent extends Equatable {
  const SubscriptionsEvent();
}

class InitSubscriptions extends SubscriptionsEvent {
  const InitSubscriptions();
  @override
  List<Object> get props => [];
}

class MakePurchase extends SubscriptionsEvent {
  final Package product;
  const MakePurchase({required this.product});

  @override
  List<Object> get props => [product];
}

class GetSubscriptionStatus extends SubscriptionsEvent {
  const GetSubscriptionStatus();
  @override
  List<Object?> get props => [];
}

class RestoreSubscriptions extends SubscriptionsEvent {
  const RestoreSubscriptions();
  @override
  List<Object?> get props => [];
}
