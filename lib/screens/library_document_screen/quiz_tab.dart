import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/quiz/quiz_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';

import '../../bloc/settings/settings_bloc.dart';

class QuizTab extends StatefulWidget {
  final String documentKey;
  final String documentText;
  const QuizTab({
    super.key,
    required this.documentKey,
    required this.documentText,
  });

  @override
  State<QuizTab> createState() => _QuizTabState();
}

class _QuizTabState extends State<QuizTab> {
  @override
  void initState() {
    super.initState();
    // Check if quiz exists, if not generate it
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final quizBloc = context.read<QuizBloc>();
      final quiz = quizBloc.state.getQuiz(widget.documentKey);
      if (quiz == null || quiz.status == QuizStatus.error) {
        quizBloc.add(GenerateQuiz(
          documentKey: widget.documentKey,
          text: widget.documentText,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizBloc, QuizState>(
      builder: (context, state) {
        final quiz = state.getQuiz(widget.documentKey);

        if (quiz == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        switch (quiz.status) {
          case QuizStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case QuizStatus.error:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.quiz_failedToGenerate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<QuizBloc>().add(GenerateQuiz(
                            documentKey: widget.documentKey,
                            text: widget.documentText,
                          ));
                    },
                    child: Text(AppLocalizations.of(context)!.quiz_retry),
                  ),
                ],
              ),
            );
          case QuizStatus.ready:
            return _QuizStartScreen(
              quiz: quiz,
              documentKey: widget.documentKey,
            );
          case QuizStatus.inProgress:
            return _QuizQuestionScreen(
              quiz: quiz,
              documentKey: widget.documentKey,
            );
          case QuizStatus.completed:
            return _QuizResultsScreen(
              quiz: quiz,
              documentKey: widget.documentKey,
            );
        }
      },
    );
  }
}

class _QuizStartScreen extends StatelessWidget {
  final Quiz quiz;
  final String documentKey;

  const _QuizStartScreen({
    required this.quiz,
    required this.documentKey,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.quiz,
                  size: 64,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.quiz_knowledgeQuiz,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.quiz_testYourUnderstanding,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _InfoRow(
                        icon: Icons.help_outline,
                        label: AppLocalizations.of(context)!.quiz_questions,
                        value: '${quiz.questions.length}',
                      ),
                      const SizedBox(height: 12),
                      _InfoRow(
                        icon: Icons.timer_outlined,
                        label: AppLocalizations.of(context)!.quiz_estimatedTime,
                        value: '${quiz.questions.length * 2} ${AppLocalizations.of(context)!.quiz_minutes}',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.read<QuizBloc>().startQuiz(documentKey);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.quiz_startQuiz,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _QuizQuestionScreen extends StatelessWidget {
  final Quiz quiz;
  final String documentKey;

  const _QuizQuestionScreen({
    required this.quiz,
    required this.documentKey,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = quiz.currentQuestionIndex ?? 0;
    if (currentIndex >= quiz.questions.length) {
      return const Center(child: CircularProgressIndicator());
    }

    final currentQuestion = quiz.questions[currentIndex];
    final hasAnswer = currentQuestion.userAnswerId != null;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 60,
            bottom: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress indicator
              QuizProgressIndicator(
                currentIndex: currentIndex + 1,
                totalQuestions: quiz.questions.length,
              ),
              const SizedBox(height: 16),
              // Question navigation dots
              QuizNavigationDots(
                quiz: quiz,
                currentIndex: currentIndex,
                documentKey: documentKey,
              ),
              const SizedBox(height: 32),
              // Question
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentQuestion.question,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: settingsState.fontSize.toDouble() + 4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              // Answer options
              ...currentQuestion.options.map((option) {
                final isSelected = option.id == currentQuestion.userAnswerId;
                final isCorrect = currentQuestion.isCorrect == true &&
                    option.id == currentQuestion.correctAnswerId;
                final isWrong = currentQuestion.isCorrect == false &&
                    option.id == currentQuestion.userAnswerId;

                Color? backgroundColor;
                Color? textColor;
                if (hasAnswer) {
                  if (isCorrect) {
                    backgroundColor = Colors.green.shade100;
                    textColor = Colors.green.shade900;
                  } else if (isWrong) {
                    backgroundColor = Colors.red.shade100;
                    textColor = Colors.red.shade900;
                  } else if (option.id == currentQuestion.correctAnswerId) {
                    backgroundColor = Colors.green.shade100;
                    textColor = Colors.green.shade900;
                  }
                } else if (isSelected) {
                  backgroundColor = Theme.of(context).primaryColor.withOpacity(0.2);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: backgroundColor ?? Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: hasAnswer
                          ? null
                          : () {
                              context.read<QuizBloc>().add(SubmitAnswer(
                                    documentKey: documentKey,
                                    questionId: currentQuestion.id,
                                    selectedAnswerId: option.id,
                                  ));
                            },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey.shade400,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      size: 16,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option.text,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: settingsState.fontSize.toDouble(),
                                      color: textColor,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                              ),
                            ),
                            if (hasAnswer && isCorrect)
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade700,
                              ),
                            if (hasAnswer && isWrong)
                              Icon(
                                Icons.cancel,
                                color: Colors.red.shade700,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              // Explanation (shown after answer)
              if (hasAnswer && currentQuestion.explanation.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            color: Colors.blue.shade700,
                            size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.quiz_explanation,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion.explanation,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: settingsState.fontSize.toDouble(),
                              color: Colors.blue.shade900,
                            ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),
              // Navigation buttons
              if (hasAnswer)
                Row(
                  children: [
                    // Previous button
                    if (currentIndex > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            context.read<QuizBloc>().add(PreviousQuestion(
                                  documentKey: documentKey,
                                ));
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Previous',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    if (currentIndex > 0) const SizedBox(width: 12),
                    // Next button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (currentIndex + 1 >= quiz.questions.length) {
                            context.read<QuizBloc>().add(CompleteQuiz(
                                  documentKey: documentKey,
                                ));
                          } else {
                            context.read<QuizBloc>().add(NextQuestion(
                                  documentKey: documentKey,
                                ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentIndex + 1 >= quiz.questions.length
                              ? AppLocalizations.of(context)!.quiz_viewResults
                              : AppLocalizations.of(context)!.quiz_nextQuestion,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class QuizNavigationDots extends StatelessWidget {
  final Quiz quiz;
  final int currentIndex;
  final String documentKey;

  const QuizNavigationDots({
    super.key,
    required this.quiz,
    required this.currentIndex,
    required this.documentKey,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: List.generate(quiz.questions.length, (index) {
        final question = quiz.questions[index];
        final isAnswered = question.userAnswerId != null;
        final isCurrent = index == currentIndex;
        final isCorrect = question.isCorrect;

        Color dotColor;
        if (isCurrent) {
          dotColor = Theme.of(context).primaryColor;
        } else if (isAnswered) {
          if (isCorrect == true) {
            dotColor = Colors.green;
          } else if (isCorrect == false) {
            dotColor = Colors.red;
          } else {
            dotColor = Colors.grey;
          }
        } else {
          dotColor = Colors.grey.shade300;
        }

        return GestureDetector(
          onTap: () {
            // Allow navigation to any question during active quiz
            context.read<QuizBloc>().add(SetQuestionIndex(
                  documentKey: documentKey,
                  index: index,
                ));
          },
          child: Container(
            width: isCurrent ? 32 : 24,
            height: isCurrent ? 32 : 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              border: isCurrent
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
              boxShadow: isCurrent
                  ? [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isCurrent ? 14 : 10,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class QuizProgressIndicator extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;

  const QuizProgressIndicator({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentIndex / totalQuestions;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context)!.quiz_questionNofTotal(currentIndex, totalQuestions),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).primaryColor,
          ),
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class _QuizResultsScreen extends StatelessWidget {
  final Quiz quiz;
  final String documentKey;

  const _QuizResultsScreen({
    required this.quiz,
    required this.documentKey,
  });

  @override
  Widget build(BuildContext context) {
    final score = quiz.scorePercentage;
    final correctCount = quiz.correctAnswersCount;
    final totalQuestions = quiz.questions.length;
    final reviewMode = quiz.reviewMode ?? ReviewMode.overview;

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            top: 60,
            bottom: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Review mode toggle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<QuizBloc>().add(SetReviewMode(
                                documentKey: documentKey,
                                mode: ReviewMode.overview,
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: reviewMode == ReviewMode.overview
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: reviewMode == ReviewMode.overview
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                        ),
                      child: Text(
                        AppLocalizations.of(context)!.quiz_overview,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: reviewMode == ReviewMode.overview
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: reviewMode == ReviewMode.overview
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<QuizBloc>().add(SetReviewMode(
                                documentKey: documentKey,
                                mode: ReviewMode.stepByStep,
                              ));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: reviewMode == ReviewMode.stepByStep
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: reviewMode == ReviewMode.stepByStep
                                ? [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ]
                                : null,
                        ),
                      child: Text(
                        AppLocalizations.of(context)!.quiz_stepByStep,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: reviewMode == ReviewMode.stepByStep
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: reviewMode == ReviewMode.stepByStep
                              ? Theme.of(context).primaryColor
                              : Colors.grey.shade600,
                        ),
                      ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Score display
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColorDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Text(
                      '${score.toInt()}%',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getScoreMessage(score, context),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        _ScoreStat(
                          label: AppLocalizations.of(context)!.quiz_correct,
                          value: '$correctCount',
                          color: Colors.green.shade300,
                        ),
                        const SizedBox(width: 24),
                        _ScoreStat(
                          label: AppLocalizations.of(context)!.quiz_total,
                          value: '$totalQuestions',
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Review content based on mode
              if (reviewMode == ReviewMode.overview) ...[
                // Overview mode - show all questions
                Text(
                  'Review Answers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ...quiz.questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return _QuestionReviewCard(
                    question: question,
                    questionNumber: index + 1,
                  );
                }),
                const SizedBox(height: 24),
                // Retake button
                ElevatedButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(ResetQuiz(
                          documentKey: documentKey,
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.quiz_retakeQuiz,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ] else ...[
                // Step by step mode - show one question at a time
                _StepByStepReviewContent(
                  quiz: quiz,
                  documentKey: documentKey,
                  settingsState: settingsState,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  String _getScoreMessage(double score, BuildContext context) {
    if (score >= 90) {
      return AppLocalizations.of(context)!.quiz_excellent;
    } else if (score >= 70) {
      return AppLocalizations.of(context)!.quiz_goodJob;
    } else if (score >= 50) {
      return AppLocalizations.of(context)!.quiz_notBad;
    } else {
      return AppLocalizations.of(context)!.quiz_keepPracticing;
    }
  }
}

class _ScoreStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _ScoreStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white70,
              ),
        ),
      ],
    );
  }
}

class _QuestionReviewCard extends StatelessWidget {
  final QuizQuestion question;
  final int questionNumber;

  const _QuestionReviewCard({
    required this.question,
    required this.questionNumber,
  });

  @override
  Widget build(BuildContext context) {
    final isCorrect = question.isCorrect == true;
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.quiz_question(questionNumber),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                question.question,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: settingsState.fontSize.toDouble() + 2,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              if (question.explanation.isNotEmpty) ...[
                Text(
                  question.explanation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: settingsState.fontSize.toDouble(),
                      ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StepByStepReviewContent extends StatelessWidget {
  final Quiz quiz;
  final String documentKey;
  final SettingsState settingsState;

  const _StepByStepReviewContent({
    required this.quiz,
    required this.documentKey,
    required this.settingsState,
  });

  @override
  Widget build(BuildContext context) {
    final currentIndex = quiz.currentQuestionIndex ?? 0;
    final currentQuestion = quiz.questions[currentIndex];
    final isCorrect = currentQuestion.isCorrect == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress indicator
        QuizProgressIndicator(
          currentIndex: currentIndex + 1,
          totalQuestions: quiz.questions.length,
        ),
        const SizedBox(height: 16),
        // Question navigation dots
        QuizNavigationDots(
          quiz: quiz,
          currentIndex: currentIndex,
          documentKey: documentKey,
        ),
        const SizedBox(height: 32),
        // Question card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isCorrect ? Icons.check : Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isCorrect ? AppLocalizations.of(context)!.quiz_correct : AppLocalizations.of(context)!.quiz_incorrect,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                currentQuestion.question,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: settingsState.fontSize.toDouble() + 4,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Options
        ...currentQuestion.options.map((option) {
          final isUserAnswer = option.id == currentQuestion.userAnswerId;
          final isCorrectAnswer = option.id == currentQuestion.correctAnswerId;

          Color? backgroundColor;
          Color? textColor;
          if (isCorrectAnswer) {
            backgroundColor = Colors.green.shade100;
            textColor = Colors.green.shade900;
          } else if (isUserAnswer && !isCorrectAnswer) {
            backgroundColor = Colors.red.shade100;
            textColor = Colors.red.shade900;
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUserAnswer || isCorrectAnswer
                      ? (isCorrectAnswer ? Colors.green : Colors.red)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  if (isCorrectAnswer)
                    Icon(Icons.check_circle, color: Colors.green.shade700)
                  else if (isUserAnswer)
                    Icon(Icons.cancel, color: Colors.red.shade700)
                  else
                    Icon(Icons.circle_outlined, color: Colors.grey.shade400),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      option.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: settingsState.fontSize.toDouble(),
                            color: textColor,
                            fontWeight: (isUserAnswer || isCorrectAnswer)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 24),
        // Explanation
        if (currentQuestion.explanation.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.quiz_explanation,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  currentQuestion.explanation,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: settingsState.fontSize.toDouble(),
                        color: Colors.blue.shade900,
                      ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 24),
        // Navigation buttons
        Row(
          children: [
            // Previous button
            if (currentIndex > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<QuizBloc>().add(SetQuestionIndex(
                          documentKey: documentKey,
                          index: currentIndex - 1,
                        ));
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.quiz_previous,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            if (currentIndex > 0) const SizedBox(width: 12),
            // Next button or Retake
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (currentIndex + 1 >= quiz.questions.length) {
                    // Last question - show retake option
                    context.read<QuizBloc>().add(ResetQuiz(
                          documentKey: documentKey,
                        ));
                  } else {
                    context.read<QuizBloc>().add(SetQuestionIndex(
                          documentKey: documentKey,
                          index: currentIndex + 1,
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  currentIndex + 1 >= quiz.questions.length
                      ? AppLocalizations.of(context)!.quiz_retakeQuiz
                      : AppLocalizations.of(context)!.quiz_nextQuestion,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

