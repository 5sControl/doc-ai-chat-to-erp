part of 'subscription_bloc.dart';

@JsonSerializable()
class SubscriptionState extends Equatable {
  final bool isSubscribed;
  const SubscriptionState({required this.isSubscribed});

  SubscriptionState copyWith({
    bool? isSubscribed,
  }) {
    return SubscriptionState(
      isSubscribed: isSubscribed ?? this.isSubscribed,
    );
  }

  @override
  List<Object> get props => [];

  factory SubscriptionState.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionStateFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionStateToJson(this);
}
