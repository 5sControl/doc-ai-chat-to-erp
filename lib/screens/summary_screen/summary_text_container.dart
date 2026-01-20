import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

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
    final ScrollController scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding:
           EdgeInsets.only(top: 60, bottom: 90, left: 15, right: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          key: Key(summaryTranslate != null && summaryTranslate!.isActive
              ? 'short'
              : 'long'),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              return Builder(
                builder: (context) {
                  if (summaryTranslate != null && summaryTranslate!.isActive) {
                    return Animate(
                      effects: const [FadeEffect()],
                      child: SelectableText.rich(TextSpan(
                          text: summaryTranslate!.translate,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontSize: state.fontSize.toDouble()))),
                    );
                  }

                  return Animate(
                    effects: const [FadeEffect()],
                    child: MarkdownBody(
                      data: summaryText,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        h1: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: state.fontSize.toDouble() + 8,
                          fontWeight: FontWeight.bold,
                        ),
                        h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontSize: state.fontSize.toDouble() + 6,
                          fontWeight: FontWeight.bold,
                        ),
                        h3: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: state.fontSize.toDouble() + 4,
                          fontWeight: FontWeight.bold,
                        ),
                        h4: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: state.fontSize.toDouble() + 2,
                          fontWeight: FontWeight.bold,
                        ),
                        h5: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble() + 1,
                          fontWeight: FontWeight.bold,
                        ),
                        h6: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                        ),
                        strong: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontWeight: FontWeight.bold,
                        ),
                        em: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontStyle: FontStyle.italic,
                        ),
                        listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                        ),
                        listIndent: 24,
                        blockquote: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                        code: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble() - 1,
                          fontFamily: 'monospace',
                          backgroundColor: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        a: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: state.fontSize.toDouble(),
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
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
