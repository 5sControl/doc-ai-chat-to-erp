import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/screens/bundle_screen/bundle_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:path_provider/path_provider.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/bloc/library/library_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/translates/translates_bloc.dart';
import 'package:summify/screens/auth/auth_screen.dart';
import 'package:summify/screens/auth/registration_screen.dart';
import 'package:summify/screens/auth/reset_password_screen.dart';
import 'package:summify/screens/onboarding_screen.dart';
import 'package:summify/screens/request_screen.dart';
import 'package:summify/screens/settings_screen/settings_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';
import 'package:summify/services/authentication.dart';
import 'package:summify/services/notify.dart';
import 'package:summify/themes/dark_theme.dart';
import 'package:summify/themes/light_theme.dart';
import 'bloc/subscriptions/subscriptions_bloc.dart';
import 'bloc/summaries/summaries_bloc.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  // await HydratedBloc.storage.clear();
  runApp(const SummishareApp());
}

class SummishareApp extends StatelessWidget {
  const SummishareApp({super.key});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      final facebookAppEvents = FacebookAppEvents();
      facebookAppEvents.setAutoLogAppEventsEnabled(true);
    }

    final AuthService authService = AuthService();
    final brightness = MediaQuery.of(context).platformBrightness;
    final settingsBloc = SettingsBloc(brightness: brightness);
    final mixpanelBloc = MixpanelBloc(settingsBloc: settingsBloc);

    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TranslatesBloc(mixpanelBloc: mixpanelBloc)),
          BlocProvider(
              create: (context) => ResearchBloc(mixpanelBloc: mixpanelBloc)),
          BlocProvider(create: (context) => settingsBloc),
          BlocProvider(create: (context) => LibraryBloc()),
          BlocProvider(
            create: (context) => mixpanelBloc,
          ),
          BlocProvider(
            create: (context) => SubscriptionsBloc(
              mixpanelBloc: mixpanelBloc,
            ),
          ),
          BlocProvider(
              create: (context) => SummariesBloc(
                  mixpanelBloc: mixpanelBloc,
                  subscriptionBloc: context.read<SubscriptionsBloc>())),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authService: authService)),
          BlocProvider(create: (context) => OffersBloc()),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            if (!settingsState.subscriptionsSynced) {
              context.read<SubscriptionsBloc>().add(const SyncSubscriptions());
              context.read<SettingsBloc>().add(const SetPurchasesSync());
            }

            context.read<SubscriptionsBloc>().add(const InitSubscriptions());

            Future<void> setSystemColor() async {
              if (settingsState.appTheme == AppTheme.dark) {
                await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
              }

              if (settingsState.appTheme == AppTheme.light) {
                await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
              }

              if (settingsState.appTheme == AppTheme.auto) {
                if (brightness == Brightness.dark) {
                  await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
                } else {
                  await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
                }
              }
            }

            setSystemColor();

            ThemeMode themeMode;
            if (settingsState.appTheme == AppTheme.auto) {
              themeMode = ThemeMode.system;
            } else if (settingsState.appTheme == AppTheme.dark) {
              themeMode = ThemeMode.dark;
            } else {
              themeMode = ThemeMode.light;
            }
            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              //builder: (context, Widget? child) => child!,
              initialRoute:
                  settingsState.onboardingPassed ? '/' : '/onboarding',
              onGenerateRoute: (settings) {
                switch (settings.name) {
                  case '/':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const MainScreen(), settings: settings);
                  //builder: (_) => const AuthScreen(), settings: settings);
                  case '/onboarding':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const OnboardingScreen(),
                        settings: settings);
                  case '/login':
                    return MaterialWithModalsPageRoute(
                        builder: (_) =>const AuthScreen(), settings: settings);
                  case '/subscribe':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SubscriptionScreen(
                              triggerScreen: 'Home', showBackArrow: true,
                            ),
                        settings: settings);
                  case '/bundle':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const BundleScreen(
                              triggerScreen: 'Home',
                            ),
                        settings: settings);
                  case '/settings':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SettingsScreen(),
                        settings: settings);
                  case '/request':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const RequestScreen(),
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
