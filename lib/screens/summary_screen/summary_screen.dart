import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/offers/offers_bloc.dart';
import 'package:summify/bloc/offers/offers_event.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/helpers/get_transformed_text.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/screens/bundle_screen/bundle_screen.dart';
import 'package:summify/screens/home_screen/home_screen.dart';
import 'package:summify/screens/modal_screens/rate_summary_screen.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'package:summify/screens/summary_screen/research_tab.dart';
import 'package:summify/screens/summary_screen/send_request_field.dart';
import 'package:summify/screens/summary_screen/summary_hero_image.dart';
import 'package:summify/screens/summary_screen/share_copy_button.dart';
import 'package:summify/screens/summary_screen/summary_text_container.dart';
import 'package:summify/screens/summary_screen/word_lookup_overlay.dart';
import 'package:summify/screens/summary_screen/knowledge_cards/knowledge_cards_tab.dart';
import 'package:summify/screens/library_document_screen/quiz_tab.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toastification/toastification.dart';

import 'package:summify/services/tts_service.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/translates/translates_bloc.dart';
import '../../gen/assets.gen.dart';
import '../../models/models.dart';
import '../../widgets/backgroung_gradient.dart';
import '../subscribtions_screen/subscriptions_screen.dart';
import 'custom_tab_bar.dart';
import 'header.dart';
import 'info_modal/original_text_modal.dart';

class SummaryScreen extends StatefulWidget {
  final String summaryKey;
  const SummaryScreen({super.key, required this.summaryKey});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int activeTab;

  @override
  void initState() {
    final AB = context.read<SettingsBloc>().state.abTest == 'A' ? 2 : 1;

    setState(() {
      activeTab = context.read<SettingsBloc>().state.abTest == 'A' ? 2 : 1;
    });
    _tabController = TabController(length: 6, vsync: this, initialIndex: AB);
    if (context.read<SummariesBloc>().state.ratedSummaries.contains(
      widget.summaryKey,
    )) {
      context.read<MixpanelBloc>().add(
        ShowSummaryAgain(url: widget.summaryKey),
      );
    }
    _tabController.addListener(() {
      // Stop TTS when switching tabs
      TtsService.instance.stop();
      
      setState(() {
        activeTab = _tabController.index;
        String tabType;
        switch (activeTab) {
          case 0:
            tabType = 'source';
            break;
          case 1:
            tabType = 'short';
            break;
          case 2:
            tabType = 'long';
            break;
          case 3:
            tabType = 'research';
            break;
          case 4:
            tabType = 'quiz';
            break;
          case 5:
            tabType = 'knowledge_cards';
            break;
          default:
            tabType = 'unknown';
        }

        context.read<MixpanelBloc>().add(
          ReadSummary(
            type: tabType,
            url: widget.summaryKey,
            AB: context.read<SettingsBloc>().state.abTest,
          ),
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    TtsService.instance.stop();
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

            final displayLink =
                summaryData.summaryPreview.title ??
                widget.summaryKey.replaceAll('https://', '');

            final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
            final String formattedDate = formatter.format(summaryData.date);

            final sourceText =
                summaryData.summaryOrigin == SummaryOrigin.text &&
                        summaryData.userText != null
                    ? summaryData.userText!
                    : AppLocalizations.of(context)!.summary_sourceNotAvailable;

            final briefSummaryText = getTransformedText(
              text: summaryData.shortSummary.summaryText ?? '',
            );

            final deepSummaryText = getTransformedText(
              text: summaryData.longSummary.summaryText ?? '',
            );

            void showRateScreen() {
              showMaterialModalBottomSheet(
                context: context,
                expand: false,
                bounce: false,
                barrierColor: Colors.black54,
                backgroundColor: Colors.transparent,
                enableDrag: false,
                builder: (context) {
                  return RateSummaryScreen(summaryLink: widget.summaryKey);
                },
              );
            }

            void onPressBack() {
              final subscriptionStatus =
                  BlocProvider.of<SubscriptionsBloc>(
                    context,
                  ).state.subscriptionStatus;
              if (!state.ratedSummaries.contains(widget.summaryKey)) {
                showRateScreen();
              } else {
                subscriptionStatus != SubscriptionStatus.subscribed
                    ? Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => BundleScreen(
                              triggerScreen: 'Summary',
                              fromSummary: true,
                            ),
                      ),
                    )
                    : Navigator.of(context).pop();
              }
            }

            void onPressLink() async {
              switch (summaryData.summaryOrigin) {
                case SummaryOrigin.url:
                  // Open URL in browser
                  final Uri url = Uri.parse(widget.summaryKey);
                  if (!await launchUrl(url)) {
                    if (context.mounted) {
                      toastification.show(
                        context: context,
                        title: Text(
                          AppLocalizations.of(context)!.summary_couldNotOpenURL,
                        ),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
                  }
                  break;

                case SummaryOrigin.file:
                  // Open file in external app
                  if (summaryData.filePath != null) {
                    final file = File(summaryData.filePath!);
                    if (await file.exists()) {
                      try {
                        await Share.shareXFiles([
                          XFile(summaryData.filePath!),
                        ], subject: displayLink);
                      } catch (e) {
                        if (context.mounted) {
                          toastification.show(
                            context: context,
                            title: Text(
                              AppLocalizations.of(
                                context,
                              )!.summary_couldNotOpenFile,
                            ),
                            type: ToastificationType.error,
                            autoCloseDuration: const Duration(seconds: 3),
                          );
                        }
                      }
                    } else {
                      if (context.mounted) {
                        toastification.show(
                          context: context,
                          title: Text(
                            AppLocalizations.of(
                              context,
                            )!.summary_originalFileNoLongerAvailable,
                          ),
                          type: ToastificationType.warning,
                          autoCloseDuration: const Duration(seconds: 3),
                        );
                      }
                    }
                  } else {
                    if (context.mounted) {
                      toastification.show(
                        context: context,
                        title: Text(
                          AppLocalizations.of(
                            context,
                          )!.summary_filePathNotFound,
                        ),
                        type: ToastificationType.error,
                        autoCloseDuration: const Duration(seconds: 3),
                      );
                    }
                  }
                  break;

                case SummaryOrigin.text:
                  // Show modal with original text
                  if (summaryData.userText != null) {
                    showCupertinoModalBottomSheet(
                      context: context,
                      expand: false,
                      bounce: false,
                      barrierColor: Colors.black54,
                      backgroundColor: Colors.transparent,
                      builder: (context) {
                        return OriginalTextModal(
                          originalText: summaryData.userText!,
                        );
                      },
                    );
                  } else {
                    toastification.show(
                      context: context,
                      title: Text(
                        AppLocalizations.of(
                          context,
                        )!.summary_originalTextNotAvailable,
                      ),
                      type: ToastificationType.error,
                      autoCloseDuration: const Duration(seconds: 3),
                    );
                  }
                  break;
              }
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
                void onWordLookup(BuildContext ctx, String word) {
                  final targetLang = ctx.read<SettingsBloc>().state.translateLanguage;
                  showWordLookupOverlay(
                    ctx,
                    word: word,
                    targetLang: targetLang,
                    onSpeakWord: (w) async {
                      if (await TtsService.instance.isModelDownloaded()) {
                        if (!ctx.mounted) return;
                        final settings = ctx.read<SettingsBloc>().state;
                        TtsService.instance.speak(
                          text: w,
                          voiceId: settings.kokoroVoiceId,
                          speed: settings.kokoroSynthesisSpeed,
                        );
                      }
                    },
                  );
                }
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
                                      summaryText: sourceText,
                                      summary: Summary(summaryText: sourceText),
                                      summaryStatus: SummaryStatus.complete,
                                      summaryTranslate: null,
                                      onWordLookup: onWordLookup,
                                    ),
                                    SummaryTextContainer(
                                      summaryText: briefSummaryText,
                                      summary: summaryData.shortSummary,
                                      summaryStatus:
                                          summaryData.shortSummaryStatus,
                                      summaryTranslate:
                                          translatesState.shortTranslates[widget
                                              .summaryKey],
                                      onWordLookup: onWordLookup,
                                    ),
                                    SummaryTextContainer(
                                      summaryText: deepSummaryText,
                                      summary: summaryData.longSummary,
                                      summaryStatus:
                                          summaryData.longSummaryStatus,
                                      summaryTranslate:
                                          translatesState.longTranslates[widget
                                              .summaryKey],
                                      onWordLookup: onWordLookup,
                                    ),
                                    ResearchTab(summaryKey: widget.summaryKey),
                                    QuizTab(
                                      documentKey: widget.summaryKey,
                                      documentText: deepSummaryText,
                                    ),
                                    KnowledgeCardsTab(
                                      summaryKey: widget.summaryKey,
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    height: 68,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: gradientColors,
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: CustomTabBar(
                                        tabController: _tabController,
                                      ),
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
                      bottomNavigationBar: _buildBottomBar(
                        activeTab,
                        summaryData,
                      ),
                    ),
                    if (summaryData.isBlocked != null && summaryData.isBlocked!)
                      const PremiumBlurContainer(),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget? _buildBottomBar(int activeTab, summaryData) {
    // activeTab 0: source
    // activeTab 1: brief summary
    // activeTab 2: deep summary
    // activeTab 3: research (Chat)
    // activeTab 4: quiz
    // activeTab 5: knowledge cards

    if (activeTab == 3) {
      // Show chat input for Research tab
      return SendRequestField(
        summaryKey: widget.summaryKey,
        summaryData: summaryData,
      );
    } else if (activeTab == 0 || activeTab == 1 || activeTab == 2) {
      // Show Share/Copy/Translate buttons only for text tabs (Source, Brief and Deep)
      return ShareAndCopyButton(
        activeTab: activeTab,
        sharedLink: widget.summaryKey,
        summaryData: summaryData,
      );
    } else {
      // For Quiz tab (4) and Knowledge Cards tab (5) - show nothing
      return null;
    }
  }
}

class PremiumBlurContainer extends StatelessWidget {
  const PremiumBlurContainer({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressPremium() {
      context.read<OffersBloc>().add(NextScreenEvent());
      // showCupertinoModalBottomSheet(
      //   context: context,
      //   expand: false,
      //   bounce: false,
      //   barrierColor: Colors.black54,
      //   backgroundColor: Colors.transparent,
      //   builder: (context) {
      //     return const SubscriptionScreenLimit(
      //       fromOnboarding: true,
      //       triggerScreen: 'Summary_Screen',
      //       fromSettings: false,
      //     );
      //   },
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => SubscriptionScreenLimit(
                triggerScreen: 'Summary',
                fromSettings: true,
              ),
        ),
      );
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height:
            MediaQuery.of(context).size.height -
            240 -
            MediaQuery.of(context).padding.bottom,
        width: double.infinity,
        //margin: //EdgeInsets.only(
        //left: 15,
        //right: 15,
        //bottom: MediaQuery.of(context).padding.bottom),
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
                      end: Alignment.bottomCenter,
                    ),
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
                          horizontal: 30,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              Assets.icons.crown,
                              height: 34,
                              width: 34,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              AppLocalizations.of(
                                context,
                              )!.summary_breakThroughTheLimits,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
