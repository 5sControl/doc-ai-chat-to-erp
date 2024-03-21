import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../bloc/subscription_bloc.dart';

class IAPService {
  final BuildContext context;
  IAPService({required this.context});

  void listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print("purchaseDetails.status ${purchaseDetails.status}");
      if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        bool valid = await _verifyPurchase(purchaseDetails);
        if (valid) {
          _handleSuccessfulPurchase(purchaseDetails);
        }
      }

      if (purchaseDetails.status == PurchaseStatus.error) {
        print(purchaseDetails.error!);
      }

      if (purchaseDetails.pendingCompletePurchase) {
        await InAppPurchase.instance.completePurchase(purchaseDetails);
        print("Purchase marked complete");
      }
    });
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.productID == 'Weekly_Subscription') {
      // FirebaseService().setAccountType(uid: uid, type: 'unlimited');
      // print(purchaseDetails.status);
      // print(purchaseDetails.transactionDate);
      // print(purchaseDetails.purchaseID);
      // print(purchaseDetails.pendingCompletePurchase);
      // print(purchaseDetails.productID);
      print('Success!!!');
      context
          .read<SubscriptionBloc>()
          .add(const SetIsSubscribed(isSubscribed: true));
    }
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    print("Verifying Purchase");
    // final verifier = FirebaseFunctions.instance.httpsCallable('verifyPurchase');
    // final results = await verifier({
    //   'source': purchaseDetails.verificationData.source,
    //   'verificationData': purchaseDetails.verificationData.serverVerificationData,
    //   'productId': purchaseDetails.productID,
    // });
    // print("Called verify purchase with following result $results");
    // return results.data as bool;
    return true;
  }
}
