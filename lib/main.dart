import 'dart:async';
import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:path_provider/path_provider.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/subscription/subscription_bloc.dart';
import 'package:summify/screens/onboarding_screen.dart';
import 'package:summify/screens/settings_screen.dart';
import 'package:summify/screens/subscriptionsOnb_scree.dart';
import 'package:summify/services/authentication.dart';
import 'package:summify/services/notify.dart';
import 'package:summify/theme/baseTheme.dart';
import 'bloc/summaries/summaries_bloc.dart';
import 'firebase_options.dart';
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
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
      .copyWith(systemNavigationBarColor: Colors.teal.withOpacity(0.01)));
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  // await HydratedBloc.storage.clear();
  runApp(const SummishareApp());
}

class SummishareApp extends StatelessWidget {
  const SummishareApp({super.key});
  static final facebookAppEvents = FacebookAppEvents();
  @override
  Widget build(BuildContext context) {
    facebookAppEvents.setAutoLogAppEventsEnabled(true);
    final AuthService authService = AuthService();
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SettingsBloc()),
          BlocProvider(
            create: (context) =>
                MixpanelBloc(settingsBloc: context.read<SettingsBloc>()),
          ),
          BlocProvider(
            create: (context) => SubscriptionBloc(
                mixpanelBloc: context.read<MixpanelBloc>(),
                facebookAppEvents: facebookAppEvents),
          ),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authService: authService)),
          BlocProvider(
              create: (context) => SummariesBloc(
                  mixpanelBloc: context.read<MixpanelBloc>(),
                  subscriptionBloc: context.read<SubscriptionBloc>()))
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, settingsState) {
            context.read<SubscriptionBloc>().add(const Start());
            context
                .read<SummariesBloc>()
                .add(InitDailySummariesCount(thisDay: DateTime.now()));
            Timer.periodic(const Duration(minutes: 1), (timer) {
              context
                  .read<SummariesBloc>()
                  .add(InitDailySummariesCount(thisDay: DateTime.now()));
            });
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
                  case '/subscribe':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SubscriptionOnboardingScreen(),
                        settings: settings);
                  case '/settings':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SettingsScreen(),
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
