import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../helpers/purchases.dart';
import '../mixpanel/mixpanel_bloc.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final MixpanelBloc mixpanelBloc;

  SubscriptionsBloc({required this.mixpanelBloc})
      : super(const SubscriptionsState(
            availableProducts: null,
            subscriptionStatus: SubscriptionStatus.unsubscribed)) {
    final PurchasesService purchasesService = PurchasesService();

    on<InitSubscriptions>((event, emit) async {
      await purchasesService.initPlatformState();
      final offerings = await purchasesService.getProducts();
      if (offerings is Offerings) {
        emit(state.copyWith(availableProducts: offerings));
      }
      print(offerings);
      add(const GetSubscriptionStatus());
    });

    on<MakePurchase>((event, emit) async {
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(event.product);
        if (customerInfo
            .entitlements.all["Summify premium access"]!.isActive) {
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.subscribed));
        }
      } on PlatformException catch (e) {
        var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
          print(e);
        }
      }
    });

    on<GetSubscriptionStatus>((event, emit) async {
      try {
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        if (customerInfo.activeSubscriptions.isNotEmpty) {
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.subscribed));
        } else {
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.unsubscribed));
        }
      } on PlatformException catch (e) {
        // Error fetching customer info
      }
    });

    on<RestoreSubscriptions>((event, emit) async {
      try {
        CustomerInfo customerInfo = await Purchases.restorePurchases();
        if (customerInfo.activeSubscriptions.isNotEmpty) {
          print('restored');
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.subscribed));
        } else {
          print('nothing to restore');
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.unsubscribed));
        }
      } on PlatformException catch (e) {
        // Error restoring purchases
      }
    });
  }
}
