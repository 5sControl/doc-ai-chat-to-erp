import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/bloc/translates/translates_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/summary_screen/select_lang_dialog.dart';
import 'package:summify/services/summaryApi.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../models/models.dart';

class ButtonItem {
  final String title;
  final String icon;
  final VoidCallback action;

  ButtonItem({required this.title, required this.icon, required this.action});
}

class ShareAndCopyButton extends StatefulWidget {
  final int activeTab;
  final SummaryData summaryData;
  final String sharedLink;
  const ShareAndCopyButton(
      {super.key,
      required this.summaryData,
      required this.sharedLink,
      required this.activeTab});

  @override
  State<ShareAndCopyButton> createState() => _ShareAndCopyButtonState();
}

class _ShareAndCopyButtonState extends State<ShareAndCopyButton> {
  @override
  Widget build(BuildContext context) {
    void onPressShare() {
      final text = widget.activeTab == 0
          ? widget.summaryData.shortSummary.summaryText
          : widget.summaryData.longSummary.summaryText;

      final box = context.findRenderObject() as RenderBox?;
      Share.share(
        '${widget.sharedLink} \n\n $text',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      context.read<MixpanelBloc>().add(const ShareSummary());
    }

    void onPressCopy() {
      final text = widget.activeTab == 0
          ? widget.summaryData.shortSummary.summaryText
          : widget.summaryData.longSummary.summaryText;

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
          TranslateButton(
              summaryKey: widget.sharedLink,
              activeTab: widget.activeTab,
              summaryData: widget.summaryData)
        ],
      ),
    );
  }
}

class TranslateButton extends StatelessWidget {
  final String summaryKey;
  final int activeTab;
  final SummaryData summaryData;

  const TranslateButton(
      {super.key,
      required this.summaryKey,
      required this.activeTab,
      required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranslatesBloc, TranslatesState>(
      builder: (context, translatesState) {
        final bool isShort = activeTab == 0;

        void onPressTranslate() {
          final text = isShort
              ? summaryData.shortSummary.summaryText
              : summaryData.longSummary.summaryText;

          if (isShort && translatesState.shortTranslates[summaryKey] == null) {
            context.read<TranslatesBloc>().add(TranslateSummary(
                summaryKey: summaryKey,
                summaryText: text!,
                languageCode: 'ru',
                summaryType: SummaryType.short));
          } else if (isShort &&
              translatesState.shortTranslates[summaryKey] != null) {
            context.read<TranslatesBloc>().add(ToggleTranslate(
                summaryKey: summaryKey, summaryType: SummaryType.short));
          }

          if (!isShort && translatesState.longTranslates[summaryKey] == null) {
            context.read<TranslatesBloc>().add(TranslateSummary(
                summaryKey: summaryKey,
                summaryText: text!,
                languageCode: 'ru',
                summaryType: SummaryType.long));
          } else if (!isShort &&
              translatesState.longTranslates[summaryKey] != null) {
            context.read<TranslatesBloc>().add(ToggleTranslate(
                summaryKey: summaryKey, summaryType: SummaryType.long));
          }
        }

        bool isActive = false;

        if (activeTab == 0) {
          translatesState.shortTranslates[summaryKey] != null &&
                  translatesState.shortTranslates[summaryKey]!.isActive
              ? isActive = true
              : isActive = false;
        } else {
          translatesState.longTranslates[summaryKey] != null &&
                  translatesState.longTranslates[summaryKey]!.isActive
              ? isActive = true
              : isActive = false;
        }

        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 5, left: 5),
            child: MaterialButton(
              padding: const EdgeInsets.symmetric(vertical: 7),
              color: isActive ? Colors.white : Theme.of(context).primaryColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              onPressed: onPressTranslate,
              child: Builder(
                builder: (context) {
                  if (isShort) {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: AnimatedCrossFade(
                          firstChild: SvgPicture.asset(
                            Assets.icons.translate,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                                isActive
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.white,
                                BlendMode.srcIn),
                          ),
                          secondChild: circleLoader(),
                          crossFadeState: translatesState
                                      .shortTranslates[summaryKey]
                                      ?.translateStatus ==
                                  TranslateStatus.loading
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300)),
                    );
                  } else {
                    return SizedBox(
                      width: 24,
                      height: 24,
                      child: AnimatedCrossFade(
                          firstChild: SvgPicture.asset(
                            Assets.icons.translate,
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(
                                isActive
                                    ? Theme.of(context).primaryColorDark
                                    : Colors.white,
                                BlendMode.srcIn),
                          ),
                          secondChild: circleLoader(),
                          crossFadeState: translatesState
                                      .longTranslates[summaryKey]
                                      ?.translateStatus ==
                                  TranslateStatus.loading
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300)),
                    );
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget circleLoader() {
  return const Padding(
      padding: EdgeInsets.all(1),
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2.5,
        strokeCap: StrokeCap.round,
      ));
}
