import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/models/models.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/research/research_bloc.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/backgroung_gradient.dart';
import '../summary_screen/info_modal/extension_modal.dart';
import '../summary_screen/info_modal/text_size_modal.dart';
import '../summary_screen/research_tab.dart';

class LibraryDocumentScreen extends StatefulWidget {
  final LibraryDocument libraryDocument;
  const LibraryDocumentScreen({super.key, required this.libraryDocument});

  @override
  State<LibraryDocumentScreen> createState() => _LibraryDocumentScreenState();
}

class _LibraryDocumentScreenState extends State<LibraryDocumentScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int activeTab = 0;

  @override
  void initState() {
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: activeTab);

    _tabController.addListener(() {
      setState(() {
        activeTab = _tabController.index;
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
    final gradientColors = Theme.of(context).brightness == Brightness.dark
        ? const [
            Color.fromRGBO(15, 57, 60, 0),
            Color.fromRGBO(15, 57, 60, 1),
          ]
        : const [
            Color.fromRGBO(223, 252, 252, 0),
            Color.fromRGBO(191, 249, 249, 1),
            Color.fromRGBO(191, 249, 249, 1),
          ];

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
                      child: DocumentHeroImage(
                        libraryDocument: widget.libraryDocument,
                      ),
                    ),
                    Header(
                      libraryDocument: widget.libraryDocument,
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
                          LibraryDocumentTextContainer(
                            text: widget.libraryDocument.annotation,
                          ),
                          LibraryDocumentTextContainer(
                              text: widget.libraryDocument.summary),
                          ResearchTab(
                            summaryKey: widget.libraryDocument.title,
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
                            child: CustomTabBar(tabController: _tabController),
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
                libraryDocument: widget.libraryDocument,
              ),
              secondChild: SendRequestField(
                libraryDocument: widget.libraryDocument,
              ),
              crossFadeState: activeTab == 2
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            )),
      ],
    );
  }
}

class SendRequestField extends StatelessWidget {
  final LibraryDocument libraryDocument;
  const SendRequestField({
    super.key,
    required this.libraryDocument,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    void onPressSendRequest() {
      if (controller.text.isNotEmpty) {
        // if (summaryData.summaryOrigin == SummaryOrigin.url) {
        //   context.read<ResearchBloc>().add(MakeQuestionFromUrl(
        //       question: controller.text, summaryKey: summaryKey));
        //   context.read<MixpanelBloc>().add(TrackResearchSummary(url: summaryKey));
        // }
        //
        // if (summaryData.summaryOrigin == SummaryOrigin.file) {
        //   context.read<ResearchBloc>().add(MakeQuestionFromFile(
        //       question: controller.text,
        //       filePath: summaryData.filePath ?? '',
        //       summaryKey: summaryKey));
        //   context.read<MixpanelBloc>().add(TrackResearchSummary(url: summaryKey));
        // }
        //
        // if (summaryData.summaryOrigin == SummaryOrigin.text) {
        context.read<ResearchBloc>().add(MakeQuestionFromText(
            question: controller.text,
            text: libraryDocument.summary,
            summaryKey: libraryDocument.title));
        // context.read<MixpanelBloc>().add(TrackResearchSummary(url: summaryKey));
        // }

        controller.text = '';
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      }
    }

    final gradientColors = Theme.of(context).brightness == Brightness.dark
        ? const [
            Color.fromRGBO(15, 57, 60, 1),
            Color.fromRGBO(15, 57, 60, 0),
          ]
        : const [
            Color.fromRGBO(223, 252, 252, 1),
            Color.fromRGBO(223, 252, 252, 0),
          ];

    return Container(
      decoration: BoxDecoration(
          color: Colors.red,
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [
                0.3,
                1,
              ])),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom +
              MediaQuery.of(context).viewInsets.bottom +
              10,
          left: 15,
          right: 15),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: controller,
                cursorColor: Colors.black54,
                onFieldSubmitted: (_) {
                  onPressSendRequest();
                },
                // onTapOutside: (_) {
                //
                //   FocusScope.of(context).unfocus();
                // },
                cursorHeight: 20,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  hintText: 'Type your question about the document',
                ),
              ),
            ),
            MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
                minWidth: 40,
                height: 40,
                onPressed: onPressSendRequest,
                child: const Icon(Icons.send_rounded))
          ],
        ),
      ),
    );
  }
}

class ButtonItem {
  final String title;
  final String icon;
  final VoidCallback action;

  ButtonItem({required this.title, required this.icon, required this.action});
}

class ShareAndCopyButton extends StatefulWidget {
  final int activeTab;
  final LibraryDocument libraryDocument;

  const ShareAndCopyButton(
      {super.key, required this.libraryDocument, required this.activeTab});

  @override
  State<ShareAndCopyButton> createState() => _ShareAndCopyButtonState();
}

class _ShareAndCopyButtonState extends State<ShareAndCopyButton> {
  @override
  Widget build(BuildContext context) {
    void onPressShare() {
      final text = widget.activeTab == 0
          ? widget.libraryDocument.annotation
          : widget.libraryDocument.summary;

      final box = context.findRenderObject() as RenderBox?;
      Share.share(
        '${widget.libraryDocument.title} \n\n $text',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      context.read<MixpanelBloc>().add(const ShareSummary());
    }

    void onPressCopy() {
      final text = widget.activeTab == 0
          ? widget.libraryDocument.annotation
          : widget.libraryDocument.summary;

      Clipboard.setData(ClipboardData(text: text ?? ''));
      context.read<MixpanelBloc>().add(const CopySummary());
    }

    final List<ButtonItem> items = [
      ButtonItem(
          title: 'Share', icon: Assets.icons.share, action: onPressShare),
      ButtonItem(title: 'Copy', icon: Assets.icons.copy, action: onPressCopy),
    ];

    final gradientColors = Theme.of(context).brightness == Brightness.dark
        ? const [
            Color.fromRGBO(15, 57, 60, 1),
            Color.fromRGBO(15, 57, 60, 0),
          ]
        : const [
            Color.fromRGBO(223, 252, 252, 1),
            Color.fromRGBO(223, 252, 252, 0),
          ];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [
            0.3,
            1,
          ])),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom, left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...items
              .map(
                (button) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 5, left: 5),
                    child: MaterialButton(
                      padding: const EdgeInsets.symmetric(vertical: 7),
                      color: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      onPressed: button.action,
                      child: SvgPicture.asset(
                        button.icon,
                        width: 24,
                        height: 24,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  const CustomTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 15),
      padding: const EdgeInsets.all(1.5),
      height: 68,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: TabBar(
        controller: tabController,
        // isScrollable: true,
        labelColor: Colors.white,
        automaticIndicatorColorAdjustment: false,
        mouseCursor: null,
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        enableFeedback: false,
        padding: EdgeInsets.zero,
        splashFactory: NoSplash.splashFactory,
        unselectedLabelColor: Colors.black,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 1,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        tabAlignment: TabAlignment.fill,
        indicator: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(6)),
        tabs: const [
          Tab(
            text: "Annotation",
          ),
          Tab(text: "Summary"),
          Tab(text: "Research"),
        ],
      ),
    );
  }
}

class LibraryDocumentTextContainer extends StatelessWidget {
  final String text;

  const LibraryDocumentTextContainer({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    var keywords = [
      "INTRODUCTION",
      "CHAPTER 1:",
      "CHAPTER 2:",
      "CHAPTER 3:",
      'CHAPTER 4:',
      'CHAPTER 5:',
      'CHAPTER 6:',
      'CHAPTER 7:',
      'CHAPTER 8:',
      'CHAPTER 9:',
      'CHAPTER 10:',
      'CHAPTER 11:',
    ];
    String t = text;
    List<String> parts = [];
    for (String key in keywords) {
      t = t.replaceAll(key, '~~~$key~~~');
    }
    parts = t.split('~~~');
    parts.removeWhere((element) => element == '');

    final ScrollController scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding:
            const EdgeInsets.only(top: 50, bottom: 90, left: 15, right: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          // key: Key(summaryTranslate != null && summaryTranslate!.isActive
          //     ? 'short'
          //     : 'long'),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Builder(
                builder: (context) {
                  // if (summaryTranslate != null && summaryTranslate!.isActive) {
                  //   return Animate(
                  //     effects: const [FadeEffect()],
                  //     child: SelectableText.rich(TextSpan(
                  //         text: summaryTranslate!.translate,
                  //         style: Theme.of(context)
                  //             .textTheme
                  //             .bodyMedium!
                  //             .copyWith(fontSize: state.fontSize.toDouble()))),
                  //   );
                  // }

                  return Animate(
                    effects: const [FadeEffect()],
                    child: SelectableText.rich(TextSpan(
                        children: parts
                            .map((e) => TextSpan(
                                  text: e,
                                  style: keywords.contains(e)
                                      ? Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(
                                              height: 3,
                                              fontSize:
                                                  state.fontSize.toDouble() + 4)
                                      : Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontSize:
                                                  state.fontSize.toDouble()),
                                ))
                            .toList())),
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

class Header extends StatelessWidget {
  final LibraryDocument libraryDocument;

  const Header({
    super.key,
    required this.libraryDocument,
  });

  @override
  Widget build(BuildContext context) {
    void onPressTextSize() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return TextSizeModal();
        },
      );
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

    return Container(
      height: 180,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 15,
          right: 15,
          bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onPressTextSize,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.textScale,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: onPressDesktop,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.desctop,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: () {},
                child: Text(
                  libraryDocument.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class DocumentHeroImage extends StatelessWidget {
  final LibraryDocument libraryDocument;
  const DocumentHeroImage({super.key, required this.libraryDocument});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: libraryDocument.title,
      child: ClipRRect(
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
              sigmaX: 15, sigmaY: 15, tileMode: TileMode.mirror),
          child: Image.asset(
            libraryDocument.img,
            fit: BoxFit.cover,
            color: Colors.black54,
            colorBlendMode: BlendMode.colorBurn,
          ),
        ),
      ),
    );
  }
}
