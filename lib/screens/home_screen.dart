import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/screens/modal_screens/info_screen.dart';
import 'package:summify/screens/subscription_screen.dart';
import 'package:summify/screens/summary_screen.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../services/payment.dart';
import '../widgets/summary_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription intentMediaStreamSubscription;

  void saveLink(String summaryLink) async {
    final DateFormat formatter = DateFormat('MM.dd.yy');
    final thisDay = formatter.format(DateTime.now());
    final limit = context.read<SharedLinksBloc>().state.dailyLimit;
    final daySummaries =
        context.read<SharedLinksBloc>().state.dailySummariesMap[thisDay] ?? 15;

    Navigator.of(context).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (daySummaries >= limit) {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          // enableDrag: false,
          builder: (context) {
            return const SubscriptionScreen();
          },
        );
      } else {
        context
            .read<SharedLinksBloc>()
            .add(SaveSharedLink(sharedLink: summaryLink));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          debugPrint(
            'Shared:${value?.map((f) => f.path).join(',') ?? ''}',
          );
        }
      },
      onError: (err) {
        debugPrint('getIntentDataStream error: $err');
      },
    );

    intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
      (String value) {
        saveLink(value);
      },
      onError: (err) {
        debugPrint('getLinkStream error: $err');
      },
    );

    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      if (value != null) {
        saveLink(value);
      }
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntentPlus.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          debugPrint(
            'Shared:${value?.map((f) => f.path).join(',') ?? ''}',
          );
        }
      },
    );
  }

  @override
  void dispose() {
    intentMediaStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    void openLoadedSummary({required SharedLinksState state}) {
      final summaryLink = state.newSummaries.first;
      final SummaryData summaryData = state.savedLinks[summaryLink]!;
      final displayLink = summaryLink.replaceAll('https://', '');
      final summaryDate = summaryData.date;
      final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
      final String formattedDate = formatter.format(summaryDate);
      context
          .read<SharedLinksBloc>()
          .add(SetSummaryOpened(sharedLink: summaryLink));

      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SummaryScreen(
                  summaryData: summaryData,
                  displayLink: summaryData.title ?? displayLink,
                  formattedDate: formattedDate,
                  sharedLink: summaryLink)),
        );
      });
    }

    return PopScope(
      canPop: false,
      child: BlocConsumer<SharedLinksBloc, SharedLinksState>(
        buildWhen: (previous, current) {
          return true;
        },
        listenWhen: (previous, current) {
          return previous.newSummaries.length != current.newSummaries.length;
        },
        listener: (context, state) {
          if (state.newSummaries.isNotEmpty) {
            print('open!');
            openLoadedSummary(state: state);
          }
        },
        builder: (context, sharedLinksState) {
          final DateFormat dayFormatter = DateFormat('MM.dd.yy');
          final thisDay = dayFormatter.format(DateTime.now());
          final sharedLinks =
              sharedLinksState.savedLinks.keys.toList().reversed.toList();
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
                        availableSummaries: sharedLinksState.dailyLimit,
                        dailySummaries:
                            sharedLinksState.dailySummariesMap[thisDay] ?? 0),
                    logo(),
                    settingsButton(onPressInfo: onPressInfo),
                  ],
                )),
            body: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: ListView.builder(
                itemCount: sharedLinksState.savedLinks.length,
                itemBuilder: (context, index) {
                  return SummaryTile(
                    sharedLink: sharedLinks[index],
                    summaryData:
                        sharedLinksState.savedLinks[sharedLinks[index]]!,
                    isNew: sharedLinksState.newSummaries
                        .contains(sharedLinks[index]),
                    // summaryData: sharedLinksState.savedLinks[sharedLinks[index]]!,
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
