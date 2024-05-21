import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';

class SendRequestField extends StatelessWidget {
  final String summaryKey;
  const SendRequestField({super.key, required this.summaryKey});

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    void onPressSendRequest() {
      context
          .read<ResearchBloc>()
          .add(MakeQuestion(question: controller.text, summaryKey: summaryKey));
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
          bottom: MediaQuery.of(context).padding.bottom, left: 15, right: 15),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: controller,
                cursorColor: Colors.black54,
                cursorHeight: 20,
                style: Theme.of(context).textTheme.labelMedium,
                decoration: const InputDecoration(
                  hintText: 'Paste link',
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
