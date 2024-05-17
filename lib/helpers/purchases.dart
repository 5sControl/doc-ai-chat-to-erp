import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchasesService {
  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    late PurchasesConfiguration configuration;

    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration('');
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration('appl_CzcmziXEyjKtEOYgYuQMLCTGvtf');
    }

    await Purchases.configure(configuration);
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
