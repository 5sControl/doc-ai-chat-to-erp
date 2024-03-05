import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';

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
  static const duration = Duration(milliseconds: 200);
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
        '${widget.sharedLink} \n\n ${widget.summaryData.summary}',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }

    void onPressCopy() {
      Clipboard.setData(ClipboardData(text: widget.summaryData.summary!));
    }

    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
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
                curve: Curves.easeIn,
                duration: duration,
                scale: tappedShare ? 0.95 : 1,
                child: AnimatedContainer(
                    duration: duration,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: tappedShare
                            ? Colors.teal
                            : const Color.fromRGBO(4, 49, 57, 1),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Share',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Icon(
                              Icons.arrow_upward_sharp,
                              color: Colors.white,
                            ))
                      ],
                    )),
              ),
            ),
          ),
          GestureDetector(
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
              curve: Curves.easeIn,
              duration: duration,
              scale: tappedCopy ? 0.95 : 1,
              child: AnimatedContainer(
                  duration: duration,
                  padding: const EdgeInsets.all(6),
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                      color: tappedCopy
                          ? Colors.teal
                          : const Color.fromRGBO(4, 49, 57, 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: SvgPicture.asset(Assets.icons.file)),
            ),
          )
        ],
      ),
    );
  }
}
