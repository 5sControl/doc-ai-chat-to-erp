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
  final BuildContext context;
  final Package product;

  const MakePurchase({required this.context, required this.product});

  @override
  List<Object> get props => [product, context];
}

class GetSubscriptionStatus extends SubscriptionsEvent {
  const GetSubscriptionStatus();
  @override
  List<Object?> get props => [];
}

class RestoreSubscriptions extends SubscriptionsEvent {
  final BuildContext context;
  const RestoreSubscriptions({required this.context});
  @override
  List<Object?> get props => [context];
}

class SyncSubscriptions extends SubscriptionsEvent {
  const SyncSubscriptions();

  @override
  List<Object?> get props => [];
}


