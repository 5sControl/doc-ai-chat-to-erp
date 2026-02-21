import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/constants.dart';
import 'package:summify/services/bundle_service.dart';

import '../../../helpers/purchases.dart';
import '../../helpers/show_system_dialog.dart';
import '../../screens/modal_screens/purchase_success_screen.dart';
import '../mixpanel/mixpanel_bloc.dart';

part 'subscriptions_event.dart';
part 'subscriptions_state.dart';

(String, String) startEndDates(CustomerInfo info) {
  final entitlements = info.entitlements.all;
  BundleService bundleService = BundleService();

  String startDate = '';
  String endDate = '';

  entitlements.forEach((key, entitlement) {
    if (entitlement.isActive) {
      startDate = entitlement.originalPurchaseDate;
      endDate = entitlement.expirationDate!;
    }
  });

  return (startDate, endDate);
}

class SubscriptionsBloc extends Bloc<SubscriptionsEvent, SubscriptionsState> {
  final MixpanelBloc mixpanelBloc;
  BundleService bundleService = BundleService();

  SubscriptionsBloc({required this.mixpanelBloc})
      : super(const SubscriptionsState(
            availableProducts: null,
            subscriptionStatus: SubscriptionStatus.unsubscribed)) {
    final PurchasesService purchasesService = PurchasesService();

    on<InitSubscriptions>((event, emit) async {
      if (kIsFreeApp) {
        emit(state.copyWith(subscriptionStatus: SubscriptionStatus.subscribed));
        return;
      }
      // Only initialize if we don't already have available products
      if (state.availableProducts == null) {
        emit(SubscriptionsStateLoading(
            availableProducts: state.availableProducts,
            subscriptionStatus: state.subscriptionStatus));

        try {
          await purchasesService.initPlatformState();
          final offerings = await purchasesService.getProducts();

          if (offerings is Offerings) {
            emit(state.copyWith(availableProducts: offerings));
          }
        } catch (e) {
          // Log the error but don't prevent the app from continuing
          print('Error initializing purchases: $e');
          // Emit state without available products - the app can still function
        }

        add(const GetSubscriptionStatus());
      }
    });

    on<MakePurchase>((event, emit) async {
      if (kIsFreeApp) {
        emit(state.copyWith(subscriptionStatus: SubscriptionStatus.subscribed));
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
        return;
      }
      try {
        CustomerInfo customerInfo =
            await Purchases.purchasePackage(event.product);
        if (customerInfo.entitlements.all["Summify premium access"]?.isActive ??
            false) {
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
        } else {
          final startEnd = startEndDates(customerInfo);

          try {
            final subData = {
              'productStoreId': customerInfo.activeSubscriptions.first,
              'startDate': startEnd.$1,
              'endDate': startEnd.$2,
            };
            await bundleService.createSubscription(subData);
          } catch (e) {}
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
        if (event.context.mounted) {
          showSystemDialog(context: event.context, title: e.message.toString());
        }
      }
    });

    on<GetSubscriptionStatus>((event, emit) async {
      if (kIsFreeApp) {
        emit(state.copyWith(subscriptionStatus: SubscriptionStatus.subscribed));
        return;
      }
      try {
        User? user = FirebaseAuth.instance.currentUser;
        CustomerInfo customerInfo = await Purchases.getCustomerInfo();
        final haveSub = await bundleService.bundleInfo();
        //if (customerInfo.activeSubscriptions.isNotEmpty || (user?.uid != null && customerInfo.entitlements.all["Summify bundle access"]!.isActive)) {
        if (customerInfo.activeSubscriptions.isNotEmpty ||
            (haveSub != null && user?.uid != null && !haveSub.$3)) {
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
      if (kIsFreeApp) {
        return;
      }
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
          // Log instead of showing dialog - allows app to continue without interruption
          print('No active subscriptions found during restore');
          emit(state.copyWith(
              subscriptionStatus: SubscriptionStatus.unsubscribed));
        }
      } on PlatformException catch (e) {
        // Log error instead of showing dialog - prevents blocking app flow
        print('Error restoring subscriptions: ${e.message} (Code: ${e.code})');
        emit(state.copyWith(
            subscriptionStatus: SubscriptionStatus.unsubscribed));
      }
    });

    on<SyncSubscriptions>((event, emit) async {
      if (kIsFreeApp) {
        return;
      }
      try {
        await purchasesService.syncSubscriptions();
      } catch (e) {
        print(e);
      }
    });
  }
}
