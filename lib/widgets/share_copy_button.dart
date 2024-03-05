import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:summify/gen/assets.gen.dart';

import '../models/models.dart';

class ShareAndCopyButton extends StatelessWidget {
  final SummaryData summaryData;
  final String sharedLink;
  const ShareAndCopyButton(
      {super.key, required this.summaryData, required this.sharedLink});

  @override
  Widget build(BuildContext context) {
    void onPressShare() {
      final box = context.findRenderObject() as RenderBox?;
      Share.share(
        '$sharedLink \n\n ${summaryData.summary}',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }

    void onPressCopy() {
      Clipboard.setData( ClipboardData(text: summaryData.summary!));
    }

    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onPressShare,
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(4, 49, 57, 1),
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
          GestureDetector(
            onTap: onPressCopy,
            child: Container(
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(4, 49, 57, 1),
                    borderRadius: BorderRadius.circular(12)),
                child: SvgPicture.asset(Assets.icons.file)),
          )
        ],
      ),
    );
  }
}
