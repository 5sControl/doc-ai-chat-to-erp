import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/gen/assets.gen.dart';

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
  bool _isTextEntered = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    _controller.addListener(() {
      setState(() {
        _isTextEntered = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final TextEditingController controller = TextEditingController();

    void onPressSendRequest() {
      if (_controller.text.isNotEmpty) {
        if (widget.summaryData.summaryOrigin == SummaryOrigin.url) {
          context.read<ResearchBloc>().add(MakeQuestionFromUrl(
              question: _controller.text, summaryKey: widget.summaryKey));
          context
              .read<MixpanelBloc>()
              .add(TrackResearchSummary(url: widget.summaryKey));
        }

        if (widget.summaryData.summaryOrigin == SummaryOrigin.file) {
          context.read<ResearchBloc>().add(MakeQuestionFromFile(
              question: _controller.text,
              filePath: widget.summaryData.filePath ?? '',
              summaryKey: widget.summaryKey));
          context
              .read<MixpanelBloc>()
              .add(TrackResearchSummary(url: widget.summaryKey));
        }

        if (widget.summaryData.summaryOrigin == SummaryOrigin.text) {
          context.read<ResearchBloc>().add(MakeQuestionFromText(
              question: _controller.text,
              text: widget.summaryData.userText ?? '',
              summaryKey: widget.summaryKey));
          context
              .read<MixpanelBloc>()
              .add(TrackResearchSummary(url: widget.summaryKey));
        }

        _controller.text = '';
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
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
      child: SizedBox(
        height: 48,
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: _controller,
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
    );
  }
}
