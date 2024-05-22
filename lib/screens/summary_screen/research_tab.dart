import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/research/research_bloc.dart';
import 'package:summify/models/models.dart';

import '../../gen/assets.gen.dart';

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
    Future.delayed(const Duration(milliseconds: 200), () {
      controller.animateTo(
        controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 1000),
      );
    });
    super.initState();
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
          like: question.like,
        )
      ],
    );
  }
}

class Answer extends StatelessWidget {
  final String? answer;
  final String summaryKey;
  final AnswerStatus answerStatus;
  final Like like;
  const Answer(
      {super.key,
      required this.answer,
      required this.answerStatus,
      required this.like,
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

    void onPressLike() {
      context
          .read<ResearchBloc>()
          .add(LikeAnswer(summaryKey: summaryKey, answer: answer!));
    }

    void onPressDislike() {
      context
          .read<ResearchBloc>()
          .add(DislikeAnswer(summaryKey: summaryKey, answer: answer!));
    }

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
                            colorFilter: ColorFilter.mode(
                                like == Like.liked
                                    ? Colors.green
                                    : Colors.black54,
                                BlendMode.srcIn),
                          )),
                      IconButton(
                          onPressed: onPressDislike,
                          style: bStyle,
                          iconSize: 20,
                          visualDensity: VisualDensity.compact,
                          icon: SvgPicture.asset(
                            Assets.icons.miniDislike,
                            colorFilter: ColorFilter.mode(
                                like == Like.disliked
                                    ? Colors.red
                                    : Colors.black54,
                                BlendMode.srcIn),
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
