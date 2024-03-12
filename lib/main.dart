// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:path_provider/path_provider.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/screens/onboarding_screen.dart';
// import 'package:summify/models/models.dart';
// import 'package:summify/screens/auth/auth_screen.dart';
// import 'package:summify/screens/summary_screen.dart';
import 'package:summify/services/authentication.dart';
import 'package:summify/theme/baseTheme.dart';
import 'bloc/shared_links/shared_links_bloc.dart';
import 'firebase_options.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          buildWhen: (previous, current) => true,
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
