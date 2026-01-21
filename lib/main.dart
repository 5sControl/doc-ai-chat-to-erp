import 'dart:io';
import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/helpers/purchases.dart';
import 'package:summify/screens/bundle_screen/bundle_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'firebase_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app_links/app_links.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/bloc/library/library_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/quiz/quiz_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/translates/translates_bloc.dart';
import 'package:summify/screens/auth/auth_screen.dart';
import 'package:summify/screens/onboarding_screen.dart';
import 'package:summify/screens/request_screen.dart';
import 'package:summify/screens/saved_cards_screen/saved_cards_screen.dart';
import 'package:summify/screens/settings_screen/settings_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';
import 'package:summify/services/authentication.dart';
import 'package:summify/services/notify.dart';
import 'package:summify/themes/dark_theme.dart';
import 'package:summify/themes/light_theme.dart';
import 'bloc/subscriptions/subscriptions_bloc.dart';
import 'bloc/summaries/summaries_bloc.dart';
import 'bloc/knowledge_cards/knowledge_cards_bloc.dart';
import 'bloc/saved_cards/saved_cards_bloc.dart';
import 'screens/main_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().initNotification();

  if (kIsWeb){
    runApp(const SummishareApp());
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final purchasesService = PurchasesService();
  await purchasesService.initPlatformState();

  final storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  HydratedBloc.storage = storage;

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  if (!kIsWeb && Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  //await HydratedBloc.storage.clear();
  runApp(const SummishareApp());
}

class SummishareApp extends StatefulWidget {
  const SummishareApp({super.key});

  @override
  State<SummishareApp> createState() => _SummishareAppState();
}

class _SummishareAppState extends State<SummishareApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  late SummariesBloc _summariesBloc;
  late MixpanelBloc _mixpanelBloc;
  late SavedCardsBloc _savedCardsBloc;
  
  static const platform = MethodChannel('com.summify.share');

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    _initShareChannel();
  }

  void _initShareChannel() {
    if (!kIsWeb && Platform.isIOS) {
      platform.setMethodCallHandler((call) async {
        print('🔥 Flutter: Received method call: ${call.method}');
        
        if (call.method == 'onSharedText') {
          final List<dynamic> sharedData = call.arguments as List<dynamic>;
          print('🔥 Flutter: Shared text received: $sharedData');
          
          for (var item in sharedData) {
            if (item is String) {
              _handleSharedText(item);
            }
          }
        } else if (call.method == 'onSharedMedia') {
          final List<dynamic> sharedMedia = call.arguments as List<dynamic>;
          print('🔥 Flutter: Shared media received: $sharedMedia');
          
          for (var media in sharedMedia) {
            if (media is Map) {
              _handleSharedMedia(media);
            }
          }
        }
      });
    }
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links when app is already running
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      print('🔥 App link received (app running): $uri');
      _handleIncomingLink(uri);
    });

    // Handle the initial link if the app was opened from a link
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        print('🔥 Initial app link: $uri');
        _handleIncomingLink(uri);
      }
    } catch (e) {
      print('🔥 Error getting initial link: $e');
    }

    // For Android: Check for share intent
    if (!kIsWeb && Platform.isAndroid) {
      _checkAndroidShareIntent();
    }
  }

  void _checkAndroidShareIntent() async {
    try {
      final intent = await platform.invokeMethod('getSharedData');
      if (intent != null) {
        print('🔥 Android share intent: $intent');
        if (intent is String) {
          _handleSharedText(intent);
        } else if (intent is Map) {
          _handleSharedMedia(intent);
        }
      }
    } catch (e) {
      print('🔥 No Android share intent or error: $e');
    }
  }

  void _handleIncomingLink(Uri uri) {
    print('🔥 Handling incoming link: $uri');
    // Handle deep links if needed
  }

  void _handleSharedText(String text) {
    print('🔥 Processing shared text: $text');
    
    // Check if it's a URL
    if (text.startsWith('http://') || text.startsWith('https://')) {
      print('🔥 Detected URL, processing summary...');
      Future.delayed(const Duration(milliseconds: 500), () {
        _summariesBloc.add(GetSummaryFromUrl(summaryUrl: text, fromShare: true));
        _mixpanelBloc.add(Summify(option: 'url'));
      });
    } else {
      // Plain text
      print('🔥 Detected plain text');
      Future.delayed(const Duration(milliseconds: 500), () {
        _summariesBloc.add(GetSummaryFromText(text: text, fromShare: true));
        _mixpanelBloc.add(Summify(option: 'text'));
      });
    }
  }

  void _handleSharedMedia(Map<dynamic, dynamic> media) {
    print('🔥 Processing shared media: $media');
    
    final String? path = media['path'] as String?;
    final int? type = media['type'] as int?;
    
    if (path != null) {
      // Remove file:// prefix if present
      final cleanPath = path.replaceFirst('file://', '');
      final fileName = cleanPath.split('/').last;
      
      print('🔥 File path: $cleanPath, fileName: $fileName, type: $type');
      
      Future.delayed(const Duration(milliseconds: 500), () {
        _summariesBloc.add(GetSummaryFromFile(
          filePath: cleanPath,
          fileName: fileName,
          fromShare: true,
        ));
        _mixpanelBloc.add(Summify(option: 'file'));
      });
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final brightness = MediaQuery.of(context).platformBrightness;
    final settingsBloc = SettingsBloc(brightness: brightness);
    _mixpanelBloc = MixpanelBloc(settingsBloc: settingsBloc);
    _savedCardsBloc = SavedCardsBloc();

    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => TranslatesBloc(mixpanelBloc: _mixpanelBloc)),
          BlocProvider(
              create: (context) => ResearchBloc(mixpanelBloc: _mixpanelBloc)),
          BlocProvider(
              create: (context) => QuizBloc(mixpanelBloc: _mixpanelBloc)),
          BlocProvider(create: (context) => settingsBloc),
          BlocProvider(create: (context) => LibraryBloc()),
          BlocProvider(
            create: (context) => _mixpanelBloc,
          ),
          BlocProvider(
            create: (context) => SubscriptionsBloc(
              mixpanelBloc: _mixpanelBloc,
            ),
          ),
          BlocProvider(
              create: (context) {
                _summariesBloc = SummariesBloc(
                    mixpanelBloc: _mixpanelBloc,
                    subscriptionBloc: context.read<SubscriptionsBloc>());
                return _summariesBloc;
              }),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authService: authService)),
          BlocProvider(create: (context) => OffersBloc()),
          BlocProvider.value(value: _savedCardsBloc),
          BlocProvider(
              create: (context) => KnowledgeCardsBloc(
                mixpanelBloc: _mixpanelBloc,
                savedCardsBloc: _savedCardsBloc,
              )),
        ],
        child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, settingsState) {
              if (!settingsState.subscriptionsSynced) {
                context.read<SubscriptionsBloc>().add(const SyncSubscriptions());
                context.read<SettingsBloc>().add(const SetPurchasesSync());
              }

              context.read<SubscriptionsBloc>().add(const InitSubscriptions());

            Future<void> setSystemColor() async {
              // if (settingsState.appTheme == AppTheme.dark) {
              //   await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
              // }
              //
              // if (settingsState.appTheme == AppTheme.light) {
              //   await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
              // }
              //
              // if (settingsState.appTheme == AppTheme.auto) {
              //   if (brightness == Brightness.dark) {
              //     await StatusBarControl.setStyle(StatusBarStyle.LIGHT_CONTENT);
              //   } else {
              //     await StatusBarControl.setStyle(StatusBarStyle.DARK_CONTENT);
              //   }
              // }
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
                  case '/onboarding':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const OnboardingScreen(),
                        settings: settings);
                  case '/login':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const AuthScreen(), settings: settings);
                  case '/subscribe':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SubscriptionScreen(
                              triggerScreen: 'Home',
                              showBackArrow: true,
                            ),
                        settings: settings);
                  case '/subscribeLimit':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SubscriptionScreenLimit(
                              triggerScreen: 'Home',
                              fromSettings: false,
                            ),
                        settings: settings);
                  case '/bundle':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const BundleScreen(
                              triggerScreen: 'Home',
                              fromOnboarding: true,
                            ),
                        settings: settings);
                  case '/settings':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SettingsScreen(),
                        settings: settings);
                  case '/saved-cards':
                    return MaterialWithModalsPageRoute(
                        builder: (_) => const SavedCardsScreen(),
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
