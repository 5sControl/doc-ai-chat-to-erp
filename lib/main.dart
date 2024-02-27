import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:path_provider/path_provider.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/screens/auth/auth_screen.dart';
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
  runApp(const SummishareApp());
}

class SummishareApp extends StatefulWidget {
  const SummishareApp({super.key});

  @override
  State<SummishareApp> createState() => _SummishareAppState();
}

class _SummishareAppState extends State<SummishareApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => SharedLinksBloc(),
          ),
          BlocProvider(create: (context) => AuthenticationBloc())
        ],
        child: MaterialApp(
          theme: baseTheme,
          builder: (context, Widget? child) => child!,
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/':
                return MaterialWithModalsPageRoute(
                    builder: (_) => const MainScreen(), settings: settings);
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
        ));
  }
}
