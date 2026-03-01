import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:summify/l10n/app_localizations.dart';
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

    final l10n = AppLocalizations.of(context)!;
    final maxTime = [
      originalSummaryReadingTime.inMinutes,
      shortSummaryReadingTime.inMinutes,
      longSummaryReadingTime.inMinutes,
    ].reduce((a, b) => a > b ? a : b).toDouble();

    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 16),
                  child: Text(
                    l10n.info_productivityInfo,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: BackArrow(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _ProductivityBarChart(
                textStyle: textStyle,
                originalMinutes: originalSummaryReadingTime.inMinutes,
                briefMinutes: shortSummaryReadingTime.inMinutes,
                deepMinutes: longSummaryReadingTime.inMinutes,
                maxTime: maxTime,
                l10n: l10n,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Table(
                columnWidths: const {
                  0: IntrinsicColumnWidth(),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                },
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    children: [
                      const SizedBox.shrink(),
                      _cellRight(context, textStyle, l10n.info_words),
                      _cellRight(
                        context,
                        textStyle,
                        '${l10n.info_time}${l10n.info_timeMin}',
                      ),
                      _cellRight(
                        context,
                        textStyle,
                        '${l10n.info_saved}${l10n.info_timeMin}',
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      _cellLeft(context, textStyle, l10n.info_original),
                      _cellRight(
                          context, textStyle, originalSummaryWordsCount.toString()),
                      _cellRight(
                          context,
                          textStyle,
                          originalSummaryReadingTime.inMinutes.toString()),
                      _cellRight(context, textStyle, '–'),
                    ],
                  ),
                  TableRow(
                    children: [
                      _cellLeft(context, textStyle, l10n.info_brief),
                      _cellRight(
                          context, textStyle, shortSummaryWordsCount.toString()),
                      _cellRight(
                          context,
                          textStyle,
                          shortSummaryReadingTime.inMinutes.toString()),
                      _savedCell(context, textStyle, savedTimeShort.inMinutes.toString()),
                    ],
                  ),
                  TableRow(
                    children: [
                      _cellLeft(context, textStyle, l10n.info_deep),
                      _cellRight(
                          context, textStyle, longSummaryWordsCount.toString()),
                      _cellRight(
                          context,
                          textStyle,
                          longSummaryReadingTime.inMinutes.toString()),
                      _savedCell(context, textStyle, savedTimeLong.inMinutes.toString()),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget _cellLeft(
    BuildContext context, TextStyle textStyle, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(text, style: textStyle),
    ),
  );
}

Widget _cellRight(
    BuildContext context, TextStyle textStyle, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Align(
      alignment: Alignment.centerRight,
      child: Text(text, style: textStyle, textAlign: TextAlign.right),
    ),
  );
}

Widget _savedCell(
    BuildContext context, TextStyle textStyle, String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 4, bottom: 4),
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text, style: textStyle, textAlign: TextAlign.right),
      ),
    ),
  );
}

class _ProductivityBarChart extends StatelessWidget {
  const _ProductivityBarChart({
    required this.textStyle,
    required this.originalMinutes,
    required this.briefMinutes,
    required this.deepMinutes,
    required this.maxTime,
    required this.l10n,
  });

  final TextStyle textStyle;
  final int originalMinutes;
  final int briefMinutes;
  final int deepMinutes;
  final double maxTime;
  final AppLocalizations l10n;

  static const double _chartHeight = 100;

  @override
  Widget build(BuildContext context) {
    final barColor = Theme.of(context).primaryColor;
    return SizedBox(
      height: _chartHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: _BarColumn(
              label: l10n.info_original,
              value: originalMinutes.toDouble(),
              maxValue: maxTime,
              barColor: barColor,
              textStyle: textStyle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _BarColumn(
              label: l10n.info_brief,
              value: briefMinutes.toDouble(),
              maxValue: maxTime,
              barColor: barColor,
              textStyle: textStyle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _BarColumn(
              label: l10n.info_deep,
              value: deepMinutes.toDouble(),
              maxValue: maxTime,
              barColor: barColor,
              textStyle: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.barColor,
    required this.textStyle,
  });

  final String label;
  final double value;
  final double maxValue;
  final Color barColor;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final fraction = maxValue > 0 ? (value / maxValue).clamp(0.0, 1.0) : 0.0;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: FractionallySizedBox(
            alignment: Alignment.bottomCenter,
            heightFactor: fraction,
            child: Container(
              margin: const EdgeInsets.only(left: 4, right: 4),
              decoration: BoxDecoration(
                color: barColor.withOpacity(0.25),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
