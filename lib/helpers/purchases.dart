import 'dart:io' show Platform;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/constants.dart';

class PurchasesService {
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> initPlatformState() async {
    if (kIsFreeApp) return;
    if (!kIsWeb) {
      try {
        Purchases.setLogLevel(LogLevel.debug);

        late PurchasesConfiguration configuration;
        if (!kIsWeb && Platform.isAndroid) {
          configuration = PurchasesConfiguration('goog_ugQdxFfTdHeYrhnJzuBXhYIUtQM');
        } else if (!kIsWeb && Platform.isIOS) {
          configuration =
              PurchasesConfiguration('appl_CzcmziXEyjKtEOYgYuQMLCTGvtf');
        }
        await Purchases.configure(configuration..appUserID = user?.uid);
      } on PlatformException catch (e) {
        print('Failed to initialize RevenueCat: ${e.message} (Code: ${e.code})');
        rethrow;
      }
    } else {
      print('Purchases SDK is not supported on Web.');
    }
  }

  Future<Offerings?> getProducts() async {
    if (kIsFreeApp) return null;
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings;
      } else {
        throw Exception('No current offerings available');
      }
    } on PlatformException catch (e) {
      throw Exception('Failed to get products: ${e.message} (Code: ${e.code})');
    }
  }

  Future<void> syncSubscriptions() async {
    if (kIsFreeApp) return;
    await initPlatformState();
    await Purchases.syncPurchases();
  }
}
