// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionState _$SubscriptionStateFromJson(Map<String, dynamic> json) =>
    SubscriptionState(
      subscriptionsStatus: $enumDecode(
          _$SubscriptionsStatusEnumMap, json['subscriptionsStatus']),
      availableProducts: (json['availableProducts'] as List<dynamic>)
          .map((e) => StoreProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
      transactionStatus:
          $enumDecode(_$TransactionStatusEnumMap, json['transactionStatus']),
    );

Map<String, dynamic> _$SubscriptionStateToJson(SubscriptionState instance) =>
    <String, dynamic>{
      'subscriptionsStatus':
          _$SubscriptionsStatusEnumMap[instance.subscriptionsStatus]!,
      'transactionStatus':
          _$TransactionStatusEnumMap[instance.transactionStatus]!,
      'availableProducts': instance.availableProducts,
    };

const _$SubscriptionsStatusEnumMap = {
  SubscriptionsStatus.subscribed: 'subscribed',
  SubscriptionsStatus.unsubscribed: 'unsubscribed',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.idle: 'idle',
  TransactionStatus.pending: 'pending',
  TransactionStatus.complete: 'complete',
  TransactionStatus.error: 'error',
  TransactionStatus.canceled: 'canceled',
};
