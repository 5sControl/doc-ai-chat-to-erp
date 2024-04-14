import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';

import '../bloc/mixpanel/mixpanel_bloc.dart';
import '../models/models.dart';

class ShareAndCopyButton extends StatefulWidget {
  final SummaryData summaryData;
  final String sharedLink;
  const ShareAndCopyButton(
      {super.key, required this.summaryData, required this.sharedLink});

  @override
  State<ShareAndCopyButton> createState() => _ShareAndCopyButtonState();
}

class _ShareAndCopyButtonState extends State<ShareAndCopyButton> {
  static const duration = Duration(milliseconds: 150);
  bool tappedShare = false;
  bool tappedCopy = false;

  void onTapDown() {
    setState(() {
      tappedShare = true;
    });
  }

  void onTapUp() {
    Future.delayed(duration, () {
      setState(() {
        tappedShare = false;
      });
    });
  }

  void onTapDownCopy() {
    setState(() {
      tappedCopy = true;
    });
  }

  void onTapUpCopy() {
    Future.delayed(duration, () {
      setState(() {
        tappedCopy = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void onPressShare() {
      final box = context.findRenderObject() as RenderBox?;
      Share.share(
        '${widget.sharedLink} \n\n ${widget.summaryData.shortSummary}',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      context.read<MixpanelBloc>().add(const ShareSummary());
    }

    void onPressCopy() {
      Clipboard.setData(
          ClipboardData(text: widget.summaryData.shortSummary.summaryText ?? ''));
      context.read<MixpanelBloc>().add(const CopySummary());
    }

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromRGBO(223, 252, 252, 1),
                Color.fromRGBO(223, 252, 252, 0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: [
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
            child: GestureDetector(
              onTap: onPressShare,
              onTapDown: (_) {
                onTapDown();
              },
              onTapUp: (_) {
                onTapUp();
              },
              onTapCancel: () {
                onTapUp();
              },
              child: AnimatedScale(
                alignment: Alignment.center,
                curve: Curves.easeIn,
                duration: duration,
                scale: tappedShare ? 0.95 : 1,
                child: AnimatedContainer(
                    duration: duration,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: tappedShare
                            ? Colors.teal
                            : const Color.fromRGBO(4, 49, 57, 1),
                        borderRadius: BorderRadius.circular(12)),
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
                    )),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onPressCopy,
              onTapDown: (_) {
                onTapDownCopy();
              },
              onTapUp: (_) {
                onTapUpCopy();
              },
              onTapCancel: () {
                onTapUpCopy();
              },
              child: AnimatedScale(
                alignment: Alignment.center,
                curve: Curves.easeIn,
                duration: duration,
                scale: tappedCopy ? 0.95 : 1,
                child: AnimatedContainer(
                    duration: duration,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: tappedCopy
                            ? Colors.teal
                            : const Color.fromRGBO(4, 49, 57, 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.copy,
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'Copy',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
