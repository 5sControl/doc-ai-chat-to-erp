import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';
part 'subscription_bloc.g.dart';

class SubscriptionBloc
    extends HydratedBloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(const SubscriptionState(isSubscribed: false)) {
    on<SubscriptionEvent>((event, emit) {
      // TODO: implement event handler
    });
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
