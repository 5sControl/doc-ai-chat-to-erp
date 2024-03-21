import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:path_provider/path_provider.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/screens/onboarding_screen.dart';
import 'package:summify/services/authentication.dart';
import 'package:summify/services/notify.dart';
import 'package:summify/services/payment.dart';
import 'package:summify/theme/baseTheme.dart';
import 'bloc/shared_links/shared_links_bloc.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
      .copyWith(systemNavigationBarColor: Colors.teal.withOpacity(0.01)));
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  // await HydratedBloc.storage.clear();

  runApp(const SummishareApp());
}

class SummishareApp extends StatefulWidget {
  const SummishareApp({super.key});

  @override
  State<SummishareApp> createState() => _SummishareAppState();
}

class _SummishareAppState extends State<SummishareApp> {
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> products = [];

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {


      if (purchaseDetails.status == PurchaseStatus.pending) {
        // _showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // _handleError(purchaseDetails.error!);
          print('Error');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // print(purchaseDetails.status);
          // print(purchaseDetails.pendingCompletePurchase);
          // print(purchaseDetails.purchaseID);
          // print(purchaseDetails.transactionDate);
          // print(purchaseDetails.verificationData.localVerificationData);
          // print(purchaseDetails.verificationData.serverVerificationData);
          // print(purchaseDetails.verificationData.source);

          // bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   _deliverProduct(purchaseDetails);
          // } else {
          //   _handleInvalidPurchase(purchaseDetails);
          // }

          print('Success');
        }
        if (purchaseDetails.pendingCompletePurchase) {
          print('asdasd');
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        }
      }
    });
  }

  void loadProducts() async {
    const Set<String> _kIds = <String>{'Weekly_Subscription'};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {

    }
    setState(() {
      products = response.productDetails;
     });
    // InAppPurchase.instance.buyNonConsumable(
    //     purchaseParam: PurchaseParam(productDetails: products.first));
  }

  @override
  void initState() {
    loadProducts();
    final Stream purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (error) {
      // handle error here.
    }) as StreamSubscription<List<PurchaseDetails>>;

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SharedLinksBloc(),
          ),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authService: authService)),
          BlocProvider(create: (context) => SettingsBloc())
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            return MaterialApp(
              theme: baseTheme,
              builder: (context, Widget? child) => child!,
              initialRoute:
                  settingsState.onboardingPassed ? '/' : '/onboarding',
              onGenerateRoute: (RouteSettings settings) {
                switch (settings.name) {
                  case '/':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const MainScreen(), settings: settings);
                  case '/onboarding':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const OnboardingScreen(),
                        settings: settings);
                }
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: CupertinoScaffold(
                      body: Builder(
                        builder: (context) => CupertinoPageScaffold(
                          child: Center(
                            child: Container(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  settings: settings,
                );
              },
              debugShowCheckedModeBanner: false,
            );
          },
        ));
  }
}
