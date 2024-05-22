import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/models/models.dart';

import '../../gen/assets.gen.dart';

class ResearchTab extends StatelessWidget {
  final String summaryKey;
  const ResearchTab({super.key, required this.summaryKey});

  @override
  Widget build(BuildContext context) {
    final ScrollController controller = ScrollController();

    return BlocConsumer<ResearchBloc, ResearchState>(
      listenWhen: (previous, current) {
        if (previous.questions[summaryKey]?.length !=
            current.questions[summaryKey]?.length) {
          return true;
        }
        if (current.questions[summaryKey]?.last.answerStatus !=
            previous.questions[summaryKey]?.last.answerStatus) {
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
            children: state.questions[summaryKey]
                    ?.map(
                        (question) => AnswerAndQuestionItem(question: question))
                    .toList() ??
                [Container()],
          ),
        );
      },
    );
  }
}

class AnswerAndQuestionItem extends StatelessWidget {
  final ResearchQuestion question;
  const AnswerAndQuestionItem({
    super.key,
    required this.question,
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
          answer: question.answer,
          answerStatus: question.answerStatus,
          like: question.like,
        )
      ],
    );
  }
}

class Answer extends StatelessWidget {
  final String? answer;
  final AnswerStatus answerStatus;
  final Like like;
  const Answer(
      {super.key,
      required this.answer,
      required this.answerStatus,
      required this.like});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
    final bStyle = ButtonStyle(
        padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
        overlayColor: MaterialStatePropertyAll(
            Theme.of(context).primaryColor.withOpacity(0.5)));

    void onPressCopy() {}
    void onPressLike() {}
    void onPressDislike() {}

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
            child: AnimatedCrossFade(
              firstChild: Column(
                children: [
                  Text(
                    answer ?? '',
                    style: Theme.of(context).textTheme.labelMedium,
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
                          )),
                      IconButton(
                          onPressed: onPressLike,
                          style: bStyle,
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                          icon: SvgPicture.asset(
                            Assets.icons.miniLike,
                            colorFilter: const ColorFilter.mode(
                                Colors.black54, BlendMode.srcIn),
                          )),
                      IconButton(
                          onPressed: onPressDislike,
                          style: bStyle,
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                          icon: SvgPicture.asset(
                            Assets.icons.miniDislike,
                            colorFilter: const ColorFilter.mode(
                                Colors.black54, BlendMode.srcIn),
                          )),
                    ],
                  ),
                ],
              ),
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
  }
}

class Question extends StatelessWidget {
  final String question;
  const Question({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.7;
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
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
