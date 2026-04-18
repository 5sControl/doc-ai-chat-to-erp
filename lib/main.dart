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
import 'package:summify/l10n/app_localizations.dart';
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
import 'package:summify/screens/settings_screen/settings_group_screen.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';
import 'package:summify/screens/settings_screen/settings_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:summify/services/authentication.dart';
import 'package:summify/services/notify.dart';
import 'package:summify/services/tts_service.dart';
import 'package:summify/themes/dark_theme.dart';
import 'package:summify/themes/light_theme.dart';
import 'bloc/subscriptions/subscriptions_bloc.dart';
import 'bloc/summaries/summaries_bloc.dart';
import 'bloc/knowledge_cards/knowledge_cards_bloc.dart';
import 'bloc/saved_cards/saved_cards_bloc.dart';
import 'navigation/mixpanel_route_observer.dart';
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
  
  /// Flag to ensure pending shared data is checked only once after bloc init
  bool _pendingShareChecked = false;

  /// Shared data that arrived while user was not authenticated.
  /// Processed after successful login.
  Map<String, dynamic>? _pendingSharePayload;

  static const platform = MethodChannel('com.summify.share');

  bool get _isUserAuthenticated =>
      FirebaseAuth.instance.currentUser != null;

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

    // Note: Share intent/extension check for both iOS and Android is handled
    // by _checkPendingSharedData() which runs after blocs are initialized.
  }

  /// Checks for any pending shared data from native side (iOS and Android).
  ///
  /// BUG FIX: Solves cold start timing issue for ALL content types (URLs, text,
  /// media, files). On cold start, the native side (iOS Share Extension or Android
  /// Share Intent) may store data before Flutter's MethodChannel handler is ready.
  /// By calling 'getSharedData' via MethodChannel, we pull any pending data
  /// from the native side after blocs are initialized.
  void _checkPendingSharedData() async {
    if (kIsWeb) return;
    
    try {
      final result = await platform.invokeMethod('getSharedData');
      if (result != null) {
        print('🔥 Pending shared data received: $result');
        if (result is List) {
          // iOS returns [String] array for text/URL shares
          for (var item in result) {
            if (item is String) {
              _handleSharedText(item);
            } else if (item is Map) {
              _handleSharedMedia(item);
            }
          }
        } else if (result is String) {
          // Android returns a single String
          _handleSharedText(result);
        } else if (result is Map) {
          // Android can return a Map for media
          _handleSharedMedia(result);
        }
      }
    } catch (e) {
      print('🔥 No pending shared data or error: $e');
    }
  }

  void _handleIncomingLink(Uri uri) {
    print('🔥 Handling incoming link: $uri');
    // Handle deep links if needed
  }

  void _handleSharedText(String text) {
    print('🔥 Processing shared text: $text');

    if (!_isUserAuthenticated) {
      print('🔥 User not authenticated, storing pending share');
      _pendingSharePayload = {'type': 'text', 'data': text};
      return;
    }

    if (text.startsWith('http://') || text.startsWith('https://')) {
      print('🔥 Detected URL, processing summary...');
      Future.delayed(const Duration(milliseconds: 500), () {
        _summariesBloc.add(GetSummaryFromUrl(summaryUrl: text, fromShare: true));
        _mixpanelBloc.add(Summify(option: 'url'));
      });
    } else {
      print('🔥 Detected plain text');
      Future.delayed(const Duration(milliseconds: 500), () {
        _summariesBloc.add(GetSummaryFromText(text: text, fromShare: true));
        _mixpanelBloc.add(Summify(option: 'text'));
      });
    }
  }

  void _handleSharedMedia(Map<dynamic, dynamic> media) {
    print('🔥 Processing shared media: $media');

    if (!_isUserAuthenticated) {
      print('🔥 User not authenticated, storing pending share');
      _pendingSharePayload = {'type': 'media', 'data': Map<String, dynamic>.from(media)};
      return;
    }

    final String? path = media['path'] as String?;
    final int? type = media['type'] as int?;

    if (path != null) {
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

  void _processPendingSharePayload() {
    final payload = _pendingSharePayload;
    if (payload == null) return;
    _pendingSharePayload = null;

    final type = payload['type'] as String;
    if (type == 'text') {
      _handleSharedText(payload['data'] as String);
    } else if (type == 'media') {
      _handleSharedMedia(payload['data'] as Map<dynamic, dynamic>);
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
                
                // BUG FIX: Check for pending shared data AFTER blocs are initialized.
                // On cold start, the native side may have stored shared data before
                // Flutter was ready. Now that _summariesBloc exists, pull pending data.
                // Uses addPostFrameCallback to ensure the widget tree is fully built.
                if (!_pendingShareChecked) {
                  _pendingShareChecked = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _checkPendingSharedData();
                    if (_isUserAuthenticated) {
                      _summariesBloc.add(const FetchServerDocuments());
                    }
                  });
                }
                
                return _summariesBloc;
              }),
          BlocProvider(
              create: (context) =>
                  AuthenticationBloc(authService: authService, mixpanelBloc: _mixpanelBloc)),
          BlocProvider(create: (context) => OffersBloc()),
          BlocProvider.value(value: _savedCardsBloc),
          BlocProvider(
              create: (context) => KnowledgeCardsBloc(
                mixpanelBloc: _mixpanelBloc,
                savedCardsBloc: _savedCardsBloc,
              )),
        ],
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccessState) {
              _processPendingSharePayload();
              _summariesBloc.add(const FetchServerDocuments());
            }
          },
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

            Locale? localeFromUiCode(String code) {
              if (code == 'system' || code.isEmpty) return null;
              final normalized = code.replaceAll('_', '-');
              final parts = normalized.split('-');
              if (parts.length == 2) {
                return Locale(parts[0], parts[1]);
              }
              return Locale(parts[0]);
            }

            return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: themeMode,
              locale: localeFromUiCode(settingsState.uiLocaleCode),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              navigatorObservers: [
                MixpanelRouteObserver(_mixpanelBloc),
                _TtsRouteObserver(),
              ],
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
                  case '/settings/group': {
                    final args = settings.arguments as SettingsGroupArgs?;
                    if (args == null) {
                      return MaterialWithModalsPageRoute(
                          builder: (_) => const SettingsScreen(),
                          settings: settings);
                    }
                    return MaterialWithModalsPageRoute(
                        builder: (_) => SettingsGroupScreen(
                              groupId: args.id,
                              title: args.title,
                            ),
                        settings: settings);
                  }
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
        )),
  );
  }
}

/// RouteObserver that stops TTS when navigating away from current route
class _TtsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    // Stop TTS when navigating to a new route
    if (previousRoute != null) {
      TtsService.instance.stop();
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    // Stop TTS when popping back from a route
    TtsService.instance.stop();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    // Stop TTS when replacing a route
    if (oldRoute != null) {
      TtsService.instance.stop();
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    // Stop TTS when removing a route
    TtsService.instance.stop();
  }
}
