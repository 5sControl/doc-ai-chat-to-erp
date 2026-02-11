import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/l10n/app_localizations.dart';

import '../../models/models.dart';

class SendRequestField extends StatefulWidget {
  final String summaryKey;
  final SummaryData summaryData;
  const SendRequestField(
      {super.key, required this.summaryKey, required this.summaryData});

  @override
  State<SendRequestField> createState() => _SendRequestFieldState();
}

class _SendRequestFieldState extends State<SendRequestField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isTextEntered = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(() {
      setState(() {
        _isTextEntered = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendRequest({required String question, String? systemHint}) {
    if (question.trim().isEmpty) return;

    if (widget.summaryData.summaryOrigin == SummaryOrigin.url) {
      context.read<ResearchBloc>().add(MakeQuestionFromUrl(
        question: question.trim(),
        summaryKey: widget.summaryKey,
        systemHint: systemHint,
      ));
      context.read<MixpanelBloc>().add(TrackResearchSummary(url: widget.summaryKey));
    } else if (widget.summaryData.summaryOrigin == SummaryOrigin.file) {
      context.read<ResearchBloc>().add(MakeQuestionFromFile(
        question: question.trim(),
        filePath: widget.summaryData.filePath ?? '',
        summaryKey: widget.summaryKey,
        systemHint: systemHint,
      ));
      context.read<MixpanelBloc>().add(TrackResearchSummary(url: widget.summaryKey));
    } else if (widget.summaryData.summaryOrigin == SummaryOrigin.text) {
      context.read<ResearchBloc>().add(MakeQuestionFromText(
        question: question.trim(),
        text: widget.summaryData.userText ?? '',
        summaryKey: widget.summaryKey,
        systemHint: systemHint,
      ));
      context.read<MixpanelBloc>().add(TrackResearchSummary(url: widget.summaryKey));
    }

    _controller.text = '';
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_non_null_assertion - of(context) is non-null when inside MaterialApp
    final l10n = AppLocalizations.of(context)!;

    void onPressSendRequest() {
      if (_controller.text.isNotEmpty) {
        _sendRequest(question: _controller.text);
      }
    }

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
          color: Colors.red,
          gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              stops: const [
                0.3,
                1,
              ])),
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom +
              MediaQuery.of(context).viewInsets.bottom +
              10,
          left: 15,
          right: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(l10n.research_chipAskQuestion),
                    onPressed: () {
                      _focusNode.requestFocus();
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                ActionChip(
                  label: Text(l10n.research_chipMermaidDiagram),
                  onPressed: () {
                    _sendRequest(
                      question: l10n.research_diagramRequest,
                      systemHint: 'diagram',
                    );
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                controller: _controller,
                focusNode: _focusNode,
                cursorColor: Colors.black54,
                onFieldSubmitted: (_) {
                  onPressSendRequest();
                },
                // onTapOutside: (_) {
                //
                //   FocusScope.of(context).unfocus();
                // },
                cursorHeight: 20,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  hintText: 'Type your question about the document',
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            MaterialButton(
                color:_isTextEntered ? Color.fromRGBO(0, 186, 195, 1) : Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
                minWidth: 48,
                height: 48,
                onPressed: onPressSendRequest,
                child: SvgPicture.asset(Assets.icons.send, color: _isTextEntered ? Colors.white : Theme.of(context).primaryColor,))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
