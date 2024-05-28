import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';

import '../../models/models.dart';

class SendRequestField extends StatelessWidget {
  final String summaryKey;
  final SummaryData summaryData;
  const SendRequestField(
      {super.key, required this.summaryKey, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    void onPressSendRequest() {
      if (controller.text.isNotEmpty) {
        if (summaryData.summaryOrigin == SummaryOrigin.url) {
          context.read<ResearchBloc>().add(MakeQuestionFromUrl(
              question: controller.text, summaryKey: summaryKey));
          context.read<MixpanelBloc>().add(TrackResearchSummary(url: summaryKey));
        }

        if (summaryData.summaryOrigin == SummaryOrigin.file) {
          context.read<ResearchBloc>().add(MakeQuestionFromFile(
              question: controller.text,
              filePath: summaryData.filePath ?? '',
              summaryKey: summaryKey));
          context.read<MixpanelBloc>().add(TrackResearchSummary(url: summaryKey));
        }

        if (summaryData.summaryOrigin == SummaryOrigin.text) {
          context.read<ResearchBloc>().add(MakeQuestionFromText(
              question: controller.text,
              text: summaryData.userText ?? '',
              summaryKey: summaryKey));
          context.read<MixpanelBloc>().add(TrackResearchSummary(url: summaryKey));
        }

        controller.text = '';
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
        height: 40,
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: controller,
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
            MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
                minWidth: 40,
                height: 40,
                onPressed: onPressSendRequest,
                child: const Icon(Icons.send_rounded))
          ],
        ),
      ),
    );
  }
}
