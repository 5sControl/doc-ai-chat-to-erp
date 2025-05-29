import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class PurchasesService {
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> initPlatformState() async {

    if (!kIsWeb) {
      Purchases.setLogLevel(LogLevel.debug);

      late PurchasesConfiguration configuration;
      if (!kIsWeb && Platform.isAndroid) {
        configuration = PurchasesConfiguration('');
      } else if (!kIsWeb && Platform.isIOS) {
        configuration =
            PurchasesConfiguration('appl_CzcmziXEyjKtEOYgYuQMLCTGvtf');
      }
      await Purchases.configure(configuration..appUserID = user?.uid);
    }
    else {
      print('Purchases SDK is not supported on Web.');
    }
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
