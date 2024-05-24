import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/screens/home_screen/settings_button.dart';
import 'package:summify/screens/home_screen/summaries_counter.dart';
import 'package:summify/screens/home_screen/premium_banner.dart';

import '../modal_screens/set_up_share_screen.dart';
import '../subscribtions_screen/subscriptions_screen.dart';
import 'logo.dart';
import 'summary_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late StreamSubscription _intentMediaStreamSubscription;
  late StreamSubscription _intentTextStreamSubscription;

  void getSummary({required String summaryUrl}) {
    final DateFormat formatter = DateFormat('MM.dd.yy');
    final thisDay = formatter.format(DateTime.now());
    final limit = context.read<SummariesBloc>().state.dailyLimit;
    final daySummaries =
        context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 0;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (daySummaries >= limit) {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const SubscriptionScreen(fromOnboarding: true,);
          },
        );
        context
            .read<MixpanelBloc>()
            .add(LimitReached(resource: summaryUrl, registrated: false));
      } else {
        context
            .read<SummariesBloc>()
            .add(GetSummaryFromUrl(summaryUrl: summaryUrl, fromShare: true));
      }
    });
  }

  void getSummaryFromFile(
      {required String filePath, required String fileName}) {
    final DateFormat formatter = DateFormat('MM.dd.yy');
    final thisDay = formatter.format(DateTime.now());
    final limit = context.read<SummariesBloc>().state.dailyLimit;
    final daySummaries =
        context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 0;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (daySummaries >= limit) {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const SubscriptionScreen(fromOnboarding: true,);
          },
        );
        context
            .read<MixpanelBloc>()
            .add(LimitReached(resource: fileName, registrated: false));
      } else {
        context.read<SummariesBloc>().add(GetSummaryFromFile(
            filePath: filePath, fileName: fileName, fromShare: true));
      }
    });
  }

  @override
  void initState() {
    // For sharing images coming from outside the app while the app is in the memory
    _intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          final fileName = value.first.path.split('/').last.toString();
          final filePath = value.first.path.replaceFirst('file://', '');
          getSummaryFromFile(filePath: filePath, fileName: fileName);
        }
      },
      onError: (err) {
        debugPrint('getIntentDataStream error: $err');
      },
    );
    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          final fileName = value.first.path.split('/').last.toString();
          final filePath = value.first.path.replaceFirst('file://', '');
          Future.delayed(const Duration(seconds: 1), () {
            getSummaryFromFile(filePath: filePath, fileName: fileName);
          });
        }
      },
    );
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentTextStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
      (String value) {
        getSummary(summaryUrl: value);
      },
      onError: (err) {
        debugPrint('getLinkStream error: $err');
      },
    );
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      if (value != null) {
        Future.delayed(const Duration(seconds: 1), () {
          getSummary(summaryUrl: value);
        });
      }
    });

    if (context.read<SettingsBloc>().state.howToShowed == false) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const SetUpShareScreen();
          },
        );
        context.read<SettingsBloc>().add(const HowToShowed());
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _intentMediaStreamSubscription.cancel();
    _intentTextStreamSubscription.cancel();
    super.dispose();
  }

  void onPressSettings() {
    Navigator.of(context).pushNamed('/settings');
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return BlocBuilder<SummariesBloc, SummariesState>(
            builder: (context, summariesState) {
              final DateFormat dayFormatter = DateFormat('MM.dd.yy');
              final thisDay = dayFormatter.format(DateTime.now());
              final summaries =
                  summariesState.summaries.keys.toList().reversed.toList();
              return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                builder: (context, state) {
                  final bool isSubscribed = state.subscriptionStatus ==
                      SubscriptionStatus.unsubscribed;
                  return Scaffold(
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                        flexibleSpace: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 8,
                                sigmaY: 8,
                                tileMode: TileMode.mirror),
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        bottom: isSubscribed
                            ? PreferredSize(
                                preferredSize: const Size.fromHeight(70.0),
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: const PremiumBanner()),
                              )
                            : null,
                        title: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                              SummariesCounter(
                                  availableSummaries: summariesState.dailyLimit,
                                  dailySummaries: summariesState
                                          .dailySummariesMap[thisDay] ??
                                      0),
                            const Logo(),
                            SettingsButton(onPressSettings: onPressSettings),
                          ],
                        )),
                    body: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        itemCount: summariesState.summaries.length,
                        itemBuilder: (context, index) {
                          return SummaryTile(
                            sharedLink: summaries[index],
                            // summaryData: summariesState.summaries[summaries[index]]!,
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
