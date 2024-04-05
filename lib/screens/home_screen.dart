import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/screens/modal_screens/info_screen.dart';
import 'package:summify/screens/subscription_screen.dart';

import '../gen/assets.gen.dart';
import '../widgets/summary_tile.dart';
import 'modal_screens/how_to_screen.dart';

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
            return const SubscriptionScreen();
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
            return const SubscriptionScreen();
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
        showMaterialModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          builder: (context) {
            return const HowToScreen();
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

  void onPressInfo() {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      bounce: false,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const InfoScreen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<SummariesBloc, SummariesState>(
        builder: (context, summariesState) {
          final DateFormat dayFormatter = DateFormat('MM.dd.yy');
          final thisDay = dayFormatter.format(DateTime.now());
          final summaries =
              summariesState.summaries.keys.toList().reversed.toList();
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
                flexibleSpace: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 0,
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    summariesCounter(
                        availableSummaries: summariesState.dailyLimit,
                        // dailySummaries: 0),
                        dailySummaries:
                            summariesState.dailySummariesMap[thisDay] ?? 0),
                    logo(),
                    settingsButton(onPressInfo: onPressInfo),
                  ],
                )),
            body: Padding(
              padding: const EdgeInsets.only(top: 5),
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
      ),
    );
  }
}

Widget summariesCounter(
    {required int dailySummaries, required int availableSummaries}) {
  return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(20)),
        child: Text(
          '$dailySummaries / $availableSummaries',
          style: const TextStyle(
              fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}

Widget logo() {
  return Expanded(
    flex: 2,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.icons.logo,
            height: 30,
            width: 30,
            colorFilter: const ColorFilter.mode(
                Color.fromRGBO(6, 49, 57, 1), BlendMode.srcIn),
          ),
          const Text(
            '  Summify',
            style: TextStyle(color: Color.fromRGBO(6, 49, 57, 1)),
          ),
        ],
      ),
    ),
  );
}

Widget settingsButton({required Function() onPressInfo}) {
  return Expanded(
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(3),
        width: 35,
        height: 35,
        child: IconButton(
          onPressed: onPressInfo,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            Assets.icons.settings,
            height: 35,
            width: 35,
            colorFilter:
                ColorFilter.mode(Colors.teal.shade900, BlendMode.srcIn),
          ),
        ),
      ),
    ),
  );
}
