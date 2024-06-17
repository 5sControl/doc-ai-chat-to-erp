import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/helpers/get_transformed_text.dart';
import 'package:summify/screens/modal_screens/rate_summary_screen.dart';
import 'package:summify/screens/summary_screen/research_tab.dart';
import 'package:summify/screens/summary_screen/send_request_field.dart';
import 'package:summify/screens/summary_screen/summary_hero_image.dart';
import 'package:summify/screens/summary_screen/share_copy_button.dart';
import 'package:summify/screens/summary_screen/summary_text_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/translates/translates_bloc.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/backgroung_gradient.dart';
import '../subscribtions_screen/subscriptions_screen.dart';
import 'custom_tab_bar.dart';
import 'header.dart';

class SummaryScreen extends StatefulWidget {
  final String summaryKey;
  const SummaryScreen({
    super.key,
    required this.summaryKey,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int activeTab;

  @override
  void initState() {
    final AB = context.read<SettingsBloc>().state.abTest == 'A' ? 1 : 0;

    setState(() {
      activeTab = context.read<SettingsBloc>().state.abTest == 'A' ? 1 : 0;
    });
    _tabController = TabController(length: 3, vsync: this, initialIndex: AB);
    if (context
        .read<SummariesBloc>()
        .state
        .ratedSummaries
        .contains(widget.summaryKey)) {
      context
          .read<MixpanelBloc>()
          .add(ShowSummaryAgain(url: widget.summaryKey));
    }
    _tabController.addListener(() {
      setState(() {
        activeTab = _tabController.index;
        context.read<MixpanelBloc>().add(ReadSummary(
            type: activeTab == 0 ? 'short' : 'long',
            url: widget.summaryKey,
            AB: context.read<SettingsBloc>().state.abTest));
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslatesBloc, TranslatesState>(
      builder: (context, translatesState) {
        return BlocBuilder<SummariesBloc, SummariesState>(
          builder: (context, state) {
            final summaryData = state.summaries[widget.summaryKey]!;

            final displayLink = summaryData.summaryPreview.title ??
                widget.summaryKey.replaceAll('https://', '');

            final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
            final String formattedDate = formatter.format(summaryData.date);

            final briefSummaryText = getTransformedText(
                text: summaryData.shortSummary.summaryText ?? '');

            final deepSummaryText = getTransformedText(
                text: summaryData.longSummary.summaryText ?? '');

            void showRateScreen() {
              showMaterialModalBottomSheet(
                context: context,
                expand: false,
                bounce: false,
                barrierColor: Colors.black54,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                builder: (context) {
                  return RateSummaryScreen(
                    summaryLink: widget.summaryKey,
                  );
                },
              );
            }

            void onPressBack() {
              if (!state.ratedSummaries.contains(widget.summaryKey)) {
                showRateScreen();
              } else {
                Navigator.of(context).pop();
              }
            }

            void onPressLink() async {
              final Uri url = Uri.parse(widget.summaryKey);
              if (!await launchUrl(url)) {}
            }

            final gradientColors =
                Theme.of(context).brightness == Brightness.dark
                    ? const [
                        Color.fromRGBO(15, 57, 60, 0),
                        Color.fromRGBO(15, 57, 60, 1),
                      ]
                    : const [
                        Color.fromRGBO(223, 252, 252, 0),
                        Color.fromRGBO(191, 249, 249, 1),
                        Color.fromRGBO(191, 249, 249, 1),
                      ];

            return BlocBuilder<TranslatesBloc, TranslatesState>(
              builder: (context, translatesState) {
                return Stack(
                  children: [
                    const BackgroundGradient(),
                    // Container(color: Colors.white38),
                    Scaffold(
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              fit: StackFit.loose,
                              children: [
                                Positioned.fill(
                                  child: SummaryHeroImage(
                                    summaryData: summaryData,
                                  ),
                                ),
                                Header(
                                  sharedLink: widget.summaryKey,
                                  displayLink: displayLink,
                                  formattedDate: formattedDate,
                                  onPressLink: onPressLink,
                                  onPressBack: onPressBack,
                                  summaryData: summaryData,
                                ),
                              ],
                            ),
                            Expanded(
                              child: Stack(
                                fit: StackFit.loose,
                                children: [
                                  TabBarView(
                                    controller: _tabController,
                                    children: [
                                      SummaryTextContainer(
                                        summaryText: briefSummaryText,
                                        summary: summaryData.shortSummary,
                                        summaryStatus:
                                            summaryData.shortSummaryStatus,
                                        summaryTranslate: translatesState
                                            .shortTranslates[widget.summaryKey],
                                      ),
                                      SummaryTextContainer(
                                        summaryText: deepSummaryText,
                                        summary: summaryData.longSummary,
                                        summaryStatus:
                                            summaryData.longSummaryStatus,
                                        summaryTranslate: translatesState
                                            .longTranslates[widget.summaryKey],
                                      ),
                                      ResearchTab(
                                        summaryKey: widget.summaryKey,
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Container(
                                      height: 64,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                        colors: gradientColors,
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      )),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: CustomTabBar(
                                            tabController: _tabController),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        extendBody: true,
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerDocked,
                        bottomNavigationBar: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: ShareAndCopyButton(
                            activeTab: activeTab,
                            sharedLink: widget.summaryKey,
                            summaryData: summaryData,
                          ),
                          secondChild: SendRequestField(
                              summaryKey: widget.summaryKey,
                              summaryData: summaryData),
                          crossFadeState: activeTab == 2
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        )),
                    const PremiumBlurContainer()
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}

class PremiumBlurContainer extends StatelessWidget {
  const PremiumBlurContainer({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressPremium() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const SubscriptionScreen(
            fromOnboarding: true,
          );
        },
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          height: MediaQuery.of(context).size.height -
              265 -
              MediaQuery.of(context).padding.bottom,
          width: double.infinity,
          margin: EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).padding.bottom),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.black26),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(255, 238, 90, 1),
                              Color.fromRGBO(255, 208, 74, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.transparent,
                        child: InkWell(
                            radius: 4,
                            highlightColor: Colors.white54,
                            borderRadius: BorderRadius.circular(4),
                            onTap: onPressPremium,
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.icons.crown,
                                      height: 34,
                                      width: 34,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Upgrade to Super Premium',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ))),
                      ),
                    ),
                  ),
                ),
              ))),
    );
  }
}
