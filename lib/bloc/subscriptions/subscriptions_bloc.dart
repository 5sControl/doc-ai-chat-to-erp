import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../helpers/purchases.dart';
import '../../helpers/show_system_dialog.dart';
import '../../screens/modal_screens/purchase_success_screen.dart';
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
      add(const GetSubscriptionStatus());
    });

    on<MakePurchase>((event, emit) async {
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(event.product);
        if (customerInfo.entitlements.all["Summify premium access"]!.isActive) {
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.subscribed));

          if (event.context.mounted) {
            showMaterialModalBottomSheet(
                context: event.context,
                expand: false,
                bounce: false,
                barrierColor: Colors.black54,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                builder: (context) {
                  return const PurchaseSuccessScreen();
                });
          }
        }
      } on PlatformException catch (e) {
        // var errorCode = PurchasesErrorHelper.getErrorCode(e);
        if (event.context.mounted) {
          showSystemDialog(context: event.context, title: e.message.toString());
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
        print(e.message);
      }
    });

    on<RestoreSubscriptions>((RestoreSubscriptions event, emit) async {
      try {
        await purchasesService.syncSubscriptions();
        CustomerInfo customerInfo = await Purchases.restorePurchases();
        if (customerInfo.activeSubscriptions.isNotEmpty) {
          if (event.context.mounted) {
            showSystemDialog(
                context: event.context,
                title: "Your subscription successfully restored");
          }

          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.subscribed));
        } else {
          if (event.context.mounted) {
            showSystemDialog(
                context: event.context,
                title: "No available subscriptions found");
          }
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.unsubscribed));
        }
      } on PlatformException catch (e) {
        if (event.context.mounted) {
          showSystemDialog(
              context: event.context,
              title: "No available subscriptions found");
        }
        print(e.message);
      }
    });

    on<SyncSubscriptions>((event, emit) async {
      try {
        await purchasesService.syncSubscriptions();
      } catch (e) {
        print(e);
      }
    });
  }
}
