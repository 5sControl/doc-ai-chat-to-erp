import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';



class PurchasesService {
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('');
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration('appl_CzcmziXEyjKtEOYgYuQMLCTGvtf');
    }

    await Purchases.configure(configuration..appUserID = user?.uid);
  }

  Future<Offerings?> getProducts() async {
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings;
      } else {
        throw Exception();
      }
    } on PlatformException catch (e) {
      throw Exception(e);
    }
  }

  Future<void> syncSubscriptions() async {
    await initPlatformState();
    await Purchases.syncPurchases();
  }
}
