import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../models/models.dart';

class SummaryTextContainer extends StatelessWidget {
  final String summaryText;
  final Summary summary;
  final SummaryStatus summaryStatus;
  final SummaryTranslate? summaryTranslate;

  const SummaryTextContainer(
      {super.key,
      required this.summaryText,
      required this.summary,
      required this.summaryStatus,
      required this.summaryTranslate});

  @override
  Widget build(BuildContext context) {
    var keywords = [
      "Summary:",
      "Key Points:",
      "In-depth Analysis:",
      "Additional Context:",
      'Supporting Evidence:',
      "Implications or Conclusions:"
    ];
    String t = summaryText;
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
          key: Key(summaryTranslate != null && summaryTranslate!.isActive
              ? 'short'
              : 'long'),
          child: Builder(
            builder: (context) {
              if (summaryTranslate != null && summaryTranslate!.isActive) {
                return Animate(
                  effects: const [FadeEffect()],
                  child: SelectableText.rich(TextSpan(
                      text: summaryTranslate!.translate,
                      style: Theme.of(context).textTheme.bodyMedium)),
                );
              }

              return BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
                  return Animate(
                    effects: const [FadeEffect()],
                    child: SelectableText.rich(TextSpan(
                        children: parts
                            .map((e) => TextSpan(
                                  text: e,
                                  style: keywords.contains(e)
                                      ? Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: state.fontSize.toDouble() + 4)
                                      : Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: state.fontSize.toDouble()),
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
