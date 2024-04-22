import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';

import '../bloc/mixpanel/mixpanel_bloc.dart';
import '../models/models.dart';

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
    final gradientColors = Theme.of(context).brightness == Brightness.dark
        ? const [
            Color.fromRGBO(15, 57, 60, 1),
            Color.fromRGBO(15, 57, 60, 0),
          ]
        : const [
            Color.fromRGBO(223, 252, 252, 1),
            Color.fromRGBO(223, 252, 252, 0),
          ];

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
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Material(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  highlightColor: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                  onTap: onPressShare,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: SvgPicture.asset(
                            Assets.icons.share,
                            height: 24,
                            width: 24,
                          ),
                        ),
                        const Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0),
              child: Material(
                color: Theme.of(context).primaryColorDark,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  highlightColor: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                  onTap: onPressCopy,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: SvgPicture.asset(
                            Assets.icons.copy,
                            height: 24,
                            width: 24,
                          ),
                        ),
                        const Text(
                          'Copy',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
