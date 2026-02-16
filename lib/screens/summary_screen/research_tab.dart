import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/helpers/chat_content_parser.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/mermaid_viewer_screen.dart';
import 'package:summify/services/demo_data_initializer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../gen/assets.gen.dart';
import 'markdown_word_tap_builder.dart';
import 'word_lookup_helper.dart';

class ResearchTab extends StatefulWidget {
  final String summaryKey;
  const ResearchTab({super.key, required this.summaryKey});

  @override
  State<ResearchTab> createState() => _ResearchTabState();
}

class _ResearchTabState extends State<ResearchTab> {
  final ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.summaryKey == DemoDataInitializer.demoKey) {
        context.read<ResearchBloc>().add(const InitializeDemoResearch());
      }
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ResearchBloc, ResearchState>(
      listenWhen: (previous, current) {
        if (previous.questions[widget.summaryKey]?.length !=
            current.questions[widget.summaryKey]?.length) {
          return true;
        }
        if (current.questions[widget.summaryKey]?.last.answerStatus !=
            previous.questions[widget.summaryKey]?.last.answerStatus) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        Future.delayed(const Duration(milliseconds: 200), () {
          controller.animateTo(
            controller.position.maxScrollExtent,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 500),
          );
        });
      },
      builder: (context, state) {
        return Scrollbar(
          controller: controller,
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.only(
                left: 15, right: 15, top: 60, bottom: 100),
            children: state.questions[widget.summaryKey]
                    ?.map((question) => AnswerAndQuestionItem(
                        question: question, summaryKey: widget.summaryKey))
                    .toList() ??
                [Container()],
          ),
        );
      },
    );
  }
}

class AnswerAndQuestionItem extends StatelessWidget {
  final String summaryKey;
  final ResearchQuestion question;
  const AnswerAndQuestionItem({
    super.key,
    required this.question,
    required this.summaryKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Question(
          question: question.question,
        ),
        Answer(
          summaryKey: summaryKey,
          answer: question.answer,
          answerStatus: question.answerStatus,
        )
      ],
    );
  }
}

class Answer extends StatelessWidget {
  final String? answer;
  final String summaryKey;
  final AnswerStatus answerStatus;
  const Answer(
      {super.key,
      required this.answer,
      required this.answerStatus,
      required this.summaryKey});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    final bStyle = ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
        overlayColor: MaterialStatePropertyAll(
            Theme.of(context).primaryColor.withOpacity(0.5)));

    void onPressCopy() {
      Clipboard.setData(ClipboardData(text: answer ?? ''));
    }

    if (answerStatus == AnswerStatus.error) {
      return Animate(
        delay: const Duration(milliseconds: 100),
        effects: const [FadeEffect()],
        child: Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: RichText(
                text: TextSpan(text: '', children: [
                  TextSpan(
                    text: 'The context is to short \nfor research...',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .copyWith(color: Colors.red.shade900),
                  ),
                ]),
              ),
            ),
          ),
        ),
      );
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final segments = parseChatContent(answer ?? '');
        final useSegments = hasMermaidSegments(segments);

        final styleSheet = MarkdownStyleSheet(
          h1: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: state.fontSize.toDouble() + 6,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          h2: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontSize: state.fontSize.toDouble() + 4,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          h3: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble() + 2,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          h4: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble() + 1,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          h5: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          h6: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          p: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            color: Colors.black87,
          ),
          strong: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          em: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            fontStyle: FontStyle.italic,
            color: Colors.black87,
          ),
          listBullet: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            color: Colors.black87,
          ),
          listIndent: 16,
          blockquote: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            fontStyle: FontStyle.italic,
            color: Colors.black54,
          ),
          code: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble() - 1,
            fontFamily: 'monospace',
            backgroundColor: Colors.grey.shade200,
            color: Colors.black87,
          ),
          codeblockDecoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          a: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: state.fontSize.toDouble(),
            color: Colors.blue.shade700,
            decoration: TextDecoration.underline,
          ),
        );

        final onWordLookup = createWordLookupHandler(context);

        Map<String, MarkdownElementBuilder> wordTapBuilders() {
          return {
            'p': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'h1': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'h2': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'h3': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'h4': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'h5': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'h6': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'li': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
            'blockquote': MarkdownWordTapBuilder(
                onWordTap: (w) {
                  final trimmed = w.trim();
                  if (trimmed.isNotEmpty) onWordLookup(context, trimmed);
                }),
          };
        }

        Widget content;
        if (useSegments) {
          final children = <Widget>[];
          var mermaidIndex = 0;
          for (final segment in segments) {
            switch (segment) {
              case TextSegment(:final markdown):
                if (markdown.isNotEmpty) {
                  children.add(MarkdownBody(
                    data: markdown,
                    selectable: true,
                    styleSheet: styleSheet,
                    builders: wordTapBuilders(),
                  ));
                }
              case MermaidSegment(:final code):
                mermaidIndex++;
                final label = segments.whereType<MermaidSegment>().length > 1
                    ? 'Diagram $mermaidIndex'
                    : 'Diagram';
                children.add(_MermaidLinkBlock(
                  label: label,
                  code: code,
                ));
            }
          }
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...children,
              Row(
                children: [
                  IconButton(
                    onPressed: onPressCopy,
                    splashRadius: 10,
                    style: bStyle,
                    iconSize: 20,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.copy,
                      colorFilter: const ColorFilter.mode(
                          Colors.black54, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ],
          );
        } else {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MarkdownBody(
                data: answer ?? '',
                selectable: true,
                styleSheet: styleSheet,
                builders: wordTapBuilders(),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: onPressCopy,
                    splashRadius: 10,
                    style: bStyle,
                    iconSize: 20,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.copy,
                      colorFilter: const ColorFilter.mode(
                          Colors.black54, BlendMode.srcIn),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Animate(
          delay: const Duration(milliseconds: 100),
          effects: const [FadeEffect()],
          child: Align(
            alignment: Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                child: AnimatedCrossFade(
                  firstChild: content,
                  secondChild: Container(
                    width: 30,
                    height: 30,
                    padding: const EdgeInsets.all(5),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: answerStatus == AnswerStatus.loading
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MermaidLinkBlock extends StatelessWidget {
  final String label;
  final String code;

  const _MermaidLinkBlock({
    required this.label,
    required this.code,
  });

  void _openViewer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => MermaidViewerScreen(
          mermaidCode: code,
          title: label,
        ),
      ),
    );
  }

  Future<void> _openMermaidLive(BuildContext context) async {
    Clipboard.setData(ClipboardData(text: code));
    final uri = Uri.parse('https://mermaid.live');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Copied – paste in Mermaid Live', style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Copied', style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final copyLabel = l10n.research_mermaidCopy;
    final openLiveLabel = l10n.research_mermaidOpenLive;

    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => _openViewer(context),
            borderRadius: BorderRadius.circular(4),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.account_tree_outlined,
                      size: 20, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.open_in_new, size: 16, color: Colors.blue.shade700),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              TextButton.icon(
                onPressed: () => _copyCode(context),
                icon: SvgPicture.asset(
                  Assets.icons.copy,
                  width: 16,
                  height: 16,
                  colorFilter: ColorFilter.mode(
                    Colors.blue.shade700,
                    BlendMode.srcIn,
                  ),
                ),
                label: Text(
                  copyLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                ),
              ),
              TextButton.icon(
                onPressed: () => _openMermaidLive(context),
                icon: Icon(Icons.open_in_new, size: 14, color: Colors.blue.shade700),
                label: Text(
                  openLiveLabel,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.blue.shade700,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Question extends StatelessWidget {
  final String question;
  const Question({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
      return Align(
          alignment: Alignment.centerRight,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(8)),
              child: Text(
                question,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: state.fontSize.toDouble(),
                    ),
              ),
            ),
          ));
    });
  }
}
