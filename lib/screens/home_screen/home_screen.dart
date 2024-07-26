import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/home_screen/settings_button.dart';
import 'package:summify/screens/home_screen/summaries_counter.dart';
import 'package:summify/screens/home_screen/premium_banner.dart';
import 'package:summify/screens/library_document_screen/library_document_screen.dart';
import 'package:summify/screens/summary_screen/info_modal/extension_modal.dart';

import '../../bloc/library/library_bloc.dart';
import '../modal_screens/set_up_share_screen.dart';
import 'home_tabs.dart';
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
    // final DateFormat formatter = DateFormat('MM.dd.yy');
    // final thisDay = formatter.format(DateTime.now());
    // final limit = context.read<SummariesBloc>().state.dailyLimit;
    // final daySummaries =
    //     context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 0;

    Future.delayed(const Duration(milliseconds: 300), () {
      // if (daySummaries >= limit) {
      //   showCupertinoModalBottomSheet(
      //     context: context,
      //     expand: false,
      //     bounce: false,
      //     barrierColor: Colors.black54,
      //     backgroundColor: Colors.transparent,
      //     builder: (context) {
      //       return const SubscriptionScreen(fromOnboarding: true,);
      //     },
      //   );
      //   context
      //       .read<MixpanelBloc>()
      //       .add(LimitReached(resource: summaryUrl, registrated: false));
      // } else {
      context
          .read<SummariesBloc>()
          .add(GetSummaryFromUrl(summaryUrl: summaryUrl, fromShare: true));
      // }
    });
  }

  void getSummaryFromFile(
      {required String filePath, required String fileName}) {
    // final DateFormat formatter = DateFormat('MM.dd.yy');
    // final thisDay = formatter.format(DateTime.now());
    // final limit = context.read<SummariesBloc>().state.dailyLimit;
    // final daySummaries =
    //     context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 0;

    Future.delayed(const Duration(milliseconds: 300), () {
      // if (daySummaries >= limit) {
      //   showCupertinoModalBottomSheet(
      //     context: context,
      //     expand: false,
      //     bounce: false,
      //     barrierColor: Colors.black54,
      //     backgroundColor: Colors.transparent,
      //     builder: (context) {
      //       return const SubscriptionScreen(fromOnboarding: true,);
      //     },
      //   );
      //   context
      //       .read<MixpanelBloc>()
      //       .add(LimitReached(resource: fileName, registrated: false));
      // } else {
      context.read<SummariesBloc>().add(GetSummaryFromFile(
          filePath: filePath, fileName: fileName, fromShare: true));
      // }
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

  void onPressDesktop() {
    showMaterialModalBottomSheet(
      context: context,
      expand: false,
      bounce: false,
      barrierColor: Colors.black54,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      builder: (context) {
        return const ExtensionModal();
      },
    );
    context.read<MixpanelBloc>().add(const OpenSummifyExtensionModal());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return BlocBuilder<SummariesBloc, SummariesState>(
            builder: (context, summariesState) {
              // final DateFormat dayFormatter = DateFormat('MM.dd.yy');
              // final thisDay = dayFormatter.format(DateTime.now());
              final summaries =
                  summariesState.summaries.keys.toList().reversed.toList();
              return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                builder: (context, state) {
                  final bool isSubscribed = state.subscriptionStatus ==
                      SubscriptionStatus.unsubscribed;
                  return DefaultTabController(
                    initialIndex: 1,
                    length: 2,
                    child: Scaffold(
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
                          bottom: PreferredSize(
                            preferredSize: Size(
                                MediaQuery.of(context).size.width,
                                isSubscribed ? 100.0 : 70),
                            child: Column(
                              children: [
                                if (isSubscribed)
                                  Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: const PremiumBanner()),
                                const HomeTabs(),
                              ],
                            ),
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // SummariesCounter(
                              //     availableSummaries: 2,
                              //     dailySummaries:
                              //         summariesState.freeSummaries >= 2
                              //             ? 2
                              //             : summariesState.freeSummaries),
                              IconButton(
                                onPressed: onPressDesktop,
                                padding: const EdgeInsets.only(right: 70),
                                visualDensity: VisualDensity.compact,
                                icon: SvgPicture.asset(
                                  Assets.icons.desctop,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.black, BlendMode.srcIn),
                                ),
                                //color: Colors.white,
                              ),
                              const Logo(),
                              SettingsButton(onPressSettings: onPressSettings),
                            ],
                          )),
                      body: TabBarView(
                        children: [
                          Padding(
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
                          BlocBuilder<LibraryBloc, LibraryState>(
                            builder: (context, libraryState) {
                              final List<String> items =
                                  libraryState.libraryDocuments.keys.toList();

                              return Container(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListView.builder(
                                  itemCount: items.length,
                                  itemBuilder: (context, index) {
                                    return LibraryDocumentTile(
                                      libraryDocument: libraryState
                                          .libraryDocuments[items[index]]!,
                                    );
                                    return Container();
                                  },
                                ),
                              );
                            },
                          ),
                        ],
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

class LibraryDocumentTile extends StatelessWidget {
  final LibraryDocument libraryDocument;

  const LibraryDocumentTile({super.key, required this.libraryDocument});

  @override
  Widget build(BuildContext context) {
    void onPressDocument() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return LibraryDocumentScreen(libraryDocument: libraryDocument);
        },
      ));
    }

    return ListTile(
      leading: null,
      trailing: null,
      minVerticalPadding: 0,
      minLeadingWidth: 0,
      horizontalTitleGap: 0,
      contentPadding:
          const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
      title: SizedBox(
        height: 80,
        child: AspectRatio(
          aspectRatio: 3.5,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor.withOpacity(0.2),
            child: InkWell(
              splashFactory: InkSplash.splashFactory,
              highlightColor: Theme.of(context).canvasColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
              onTap: onPressDocument,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 2, vertical: 2),
                          child: Hero(
                            tag: libraryDocument.title,
                            child: Image.asset(
                              libraryDocument.img,
                              fit: BoxFit.cover,
                            ),
                          ))),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            libraryDocument.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
