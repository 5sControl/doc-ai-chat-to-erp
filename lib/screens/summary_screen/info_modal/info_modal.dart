import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:summify/models/models.dart';

class InfoModal extends StatelessWidget {
  final SummaryData summaryData;
  const InfoModal({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodySmall!
        .copyWith(fontWeight: FontWeight.w400);

    final shortSummaryWordsCount =
        summaryData.shortSummary.summaryText?.split(' ').length ?? 100;
    final shortSummaryReadingTime =
        Duration(minutes: (shortSummaryWordsCount / 70).round());

    final longSummaryWordsCount =
        summaryData.longSummary.summaryText?.split(' ').length ?? 100;
    final longSummaryReadingTime =
        Duration(minutes: (longSummaryWordsCount / 70).round());

    final originalSummaryWordsCount =
        summaryData.shortSummary.contextLength ?? shortSummaryWordsCount * 20;
    final originalSummaryReadingTime =
        Duration(minutes: (originalSummaryWordsCount / 70).round());

    final savedTimeShort = originalSummaryReadingTime - shortSummaryReadingTime;
    final savedTimeLong = originalSummaryReadingTime - longSummaryReadingTime;

    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 15, top: 20),
                    child: Text(
                      'Productivity Info',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                const Padding(
                    padding: EdgeInsets.only(right: 5), child: BackArrow()),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GridView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 3.5, mainAxisSpacing: 7),
              children: [
                const SizedBox(),
                Center(
                  child: Text(
                    'Words',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(text: 'Time, ', style: textStyle),
                        TextSpan(
                            text: '(min)',
                            style: textStyle.copyWith(fontSize: 10)),
                      ])),
                ),
                Center(
                  child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(text: 'Saved, ', style: textStyle),
                        TextSpan(
                            text: '(min)',
                            style: textStyle.copyWith(fontSize: 10)),
                      ])),
                ),
                Center(
                    child: Text('Original',
                        style: textStyle, textAlign: TextAlign.center)),
                Center(
                  child: Text(
                    originalSummaryWordsCount.toString(),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    originalSummaryReadingTime.inMinutes.toString(),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    '-',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    'Brief',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    shortSummaryWordsCount.toString(),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    shortSummaryReadingTime.inMinutes.toString(),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 1.5)),
                  child: Center(
                    child: Text(
                      savedTimeShort.inMinutes.toString(),
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    'Deep',
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    longSummaryWordsCount.toString(),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Text(
                    longSummaryReadingTime.inMinutes.toString(),
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1.5)),
                    child: Center(
                        child: Text(
                      savedTimeLong.inMinutes.toString(),
                      style: textStyle,
                      textAlign: TextAlign.center,
                    ))),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      Navigator.of(context).pop();
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0.2))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.2),
        icon: Icon(
          Icons.close,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ));
  }
}
