import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/research/research_bloc.dart';

class ResearchTab extends StatelessWidget {
  final String summaryKey;
  const ResearchTab({super.key, required this.summaryKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ResearchBloc, ResearchState>(
      // buildWhen: (previous, current) {
      //   return previous.questions[summaryKey]?.length !=
      //       current.questions[summaryKey]?.length;
      // },
      builder: (context, state) {
        print(state.questions[summaryKey]);

        return Center(
          child: Text('asdasdasd'),
        );
      },
    );
  }
}
