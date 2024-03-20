import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/screens/modal_screens/info_screen.dart';
import 'package:summify/screens/summary_screen.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../widgets/summary_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription intentMediaStreamSubscription;

  void saveLink(String summaryLink) async {
    context
        .read<SharedLinksBloc>()
        .add(SaveSharedLink(sharedLink: summaryLink));
    // Navigator.of(context).pushNamed('/');
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
        print("!");
        saveLink(value);
      },
      onError: (err) {
        debugPrint('getLinkStream error: $err');
      },
    );

    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      if (value != null) {
        print("!!");
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
              Container(
                width: 35,
              ),
              Padding(
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
              Container(
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
                    colorFilter:  ColorFilter.mode(
                        Colors.teal.shade900, BlendMode.srcIn),
                  ),
                ),
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: BlocListener<SharedLinksBloc, SharedLinksState>(
          listenWhen: (previous, current) {
            return previous.newSummaries.length != current.newSummaries.length;
          },
          listener: (context, state) {
            if (state.newSummaries.isNotEmpty) {
              openLoadedSummary(state: state);
            }
          },
          child: BlocBuilder<SharedLinksBloc, SharedLinksState>(
            builder: (context, sharedLinksState) {
              final sharedLinks =
                  sharedLinksState.savedLinks.keys.toList().reversed.toList();
              return ListView.builder(
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
              );
            },
          ),
        ),
      ),
    );
  }
}
