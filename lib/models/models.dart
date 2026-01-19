import 'package:equatable/equatable.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

enum SummaryOrigin { file, url, text }

enum SummaryStatus { loading, complete, error, rejected, stopped, initial }

enum TranslateStatus { loading, complete, error, initial }
// enum SummaryType { short, long }

@JsonSerializable()
class SummaryPreview extends Equatable {
  final String? imageUrl;
  final String? title;
  const SummaryPreview({this.title, this.imageUrl});

  SummaryPreview copyWith({
    String? imageUrl,
    String? title,
  }) {
    return SummaryPreview(
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
    );
  }

  factory SummaryPreview.fromJson(Map<String, dynamic> json) =>
      _$SummaryPreviewFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryPreviewToJson(this);

  @override
  List<Object?> get props => [title, imageUrl];
}

@JsonSerializable()
class Summary extends Equatable {
  final String? summaryText;
  final String? summaryError;
  final int? contextLength;

  const Summary({this.contextLength, this.summaryText, this.summaryError});

  Summary copyWith(
      {String? summaryText, String? summaryError, int? contextLength}) {
    return Summary(
      summaryText: summaryText ?? this.summaryText,
      summaryError: summaryError ?? this.summaryError,
      contextLength: contextLength ?? this.contextLength,
    );
  }

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryToJson(this);

  @override
  List<Object?> get props => [summaryText, summaryError, contextLength];
}

@JsonSerializable()
class SummaryData extends Equatable {
  final SummaryStatus shortSummaryStatus;
  final SummaryStatus longSummaryStatus;
  final DateTime date;
  final SummaryOrigin summaryOrigin;
  final SummaryPreview summaryPreview;
  final Summary shortSummary;
  final Summary longSummary;
  final String? filePath;
  final String? userText;
  final bool? isBlocked;

  const SummaryData(
      {required this.shortSummaryStatus,
      required this.longSummaryStatus,
      required this.date,
      required this.summaryOrigin,
      required this.shortSummary,
      required this.longSummary,
      required this.summaryPreview,
      this.filePath,
      this.isBlocked,
      this.userText});

  SummaryData copyWith({
    SummaryStatus? shortSummaryStatus,
    SummaryStatus? longSummaryStatus,
    SummaryOrigin? summaryOrigin,
    DateTime? date,
    Summary? shortSummary,
    Summary? longSummary,
    SummaryPreview? summaryPreview,
    String? filePath,
    String? userText,
    bool? isBlocked,
  }) {
    return SummaryData(
        shortSummaryStatus: shortSummaryStatus ?? this.shortSummaryStatus,
        longSummaryStatus: longSummaryStatus ?? this.longSummaryStatus,
        summaryOrigin: summaryOrigin ?? this.summaryOrigin,
        date: date ?? this.date,
        shortSummary: shortSummary ?? this.shortSummary,
        longSummary: longSummary ?? this.longSummary,
        summaryPreview: summaryPreview ?? this.summaryPreview,
        filePath: filePath ?? this.filePath,
        userText: userText ?? this.userText,
        isBlocked: isBlocked ?? this.isBlocked);
  }

  factory SummaryData.fromJson(Map<String, dynamic> json) =>
      _$SummaryDataFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryDataToJson(this);

  @override
  List<Object?> get props => [
        shortSummary,
        longSummary,
        shortSummaryStatus,
        longSummaryStatus,
        date,
        summaryPreview,
        summaryOrigin,
        filePath,
        userText,
        isBlocked
      ];
}

@JsonSerializable()
class SummaryTranslate extends Equatable {
  final String? translate;
  final TranslateStatus translateStatus;
  final bool isActive;
  const SummaryTranslate(
      {required this.translate,
      required this.translateStatus,
      required this.isActive});

  SummaryTranslate copyWith({
    String? translate,
    TranslateStatus? translateStatus,
    bool? isActive,
  }) {
    return SummaryTranslate(
        translate: translate ?? this.translate,
        translateStatus: translateStatus ?? this.translateStatus,
        isActive: isActive ?? this.isActive);
  }

  factory SummaryTranslate.fromJson(Map<String, dynamic> json) =>
      _$SummaryTranslateFromJson(json);

  Map<String, dynamic> toJson() => _$SummaryTranslateToJson(this);

  @override
  List<Object?> get props => [translate, translateStatus, isActive];
}

enum AnswerStatus { loading, completed, error }

enum Like { unliked, liked, disliked }

@JsonSerializable()
class ResearchQuestion extends Equatable {
  final String question;
  final String? answer;
  final AnswerStatus answerStatus;
  final Like like;
  const ResearchQuestion(
      {required this.question,
      required this.answer,
      required this.answerStatus,
      required this.like});

  ResearchQuestion copyWith({
    String? question,
    String? answer,
    AnswerStatus? answerStatus,
    Like? like,
  }) {
    return ResearchQuestion(
        question: question ?? this.question,
        answer: answer ?? this.answer,
        answerStatus: answerStatus ?? this.answerStatus,
        like: like ?? this.like);
  }

  factory ResearchQuestion.fromJson(Map<String, dynamic> json) =>
      _$ResearchQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$ResearchQuestionToJson(this);

  @override
  List<Object?> get props => [question, answer, answerStatus, like];
}

class UserModel {
  final String? id;
  final String? email;
  final String? displayName;
  UserModel({
    this.id,
    this.email,
    this.displayName,
  });
}

class LibraryDocument extends Equatable {
  final String title;
  final String annotation;
  final String summary;
  final String img;
  const LibraryDocument(
      {required this.title,
      required this.annotation,
      required this.summary,
      required this.img});

  @override
  List<Object?> get props => [title, annotation, summary, img];
}

enum QuizStatus { loading, ready, inProgress, completed, error }

enum ReviewMode { overview, stepByStep }

class QuizOption extends Equatable {
  final String id;
  final String text;

  const QuizOption({required this.id, required this.text});

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      text: json['text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }

  @override
  List<Object?> get props => [id, text];
}

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<QuizOption> options;
  final String correctAnswerId;
  final String explanation;
  final String? userAnswerId;
  final bool? isCorrect;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswerId,
    required this.explanation,
    this.userAnswerId,
    this.isCorrect,
  });

  QuizQuestion copyWith({
    String? id,
    String? question,
    List<QuizOption>? options,
    String? correctAnswerId,
    String? explanation,
    String? userAnswerId,
    bool? isCorrect,
  }) {
    return QuizQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerId: correctAnswerId ?? this.correctAnswerId,
      explanation: explanation ?? this.explanation,
      userAnswerId: userAnswerId ?? this.userAnswerId,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    final optionsList = (json['options'] as List<dynamic>)
        .map((opt) => QuizOption.fromJson(opt as Map<String, dynamic>))
        .toList();
    
    return QuizQuestion(
      id: json['id'] as String,
      question: json['question'] as String,
      options: optionsList,
      correctAnswerId: json['correct_answer_id'] as String,
      explanation: json['explanation'] as String,
      userAnswerId: json['userAnswerId'] as String?,
      isCorrect: json['isCorrect'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((opt) => opt.toJson()).toList(),
      'correct_answer_id': correctAnswerId,
      'explanation': explanation,
      'userAnswerId': userAnswerId,
      'isCorrect': isCorrect,
    };
  }

  @override
  List<Object?> get props =>
      [id, question, options, correctAnswerId, explanation, userAnswerId, isCorrect];
}

class QuizAnswer extends Equatable {
  final String questionId;
  final String selectedAnswerId;
  final bool isCorrect;
  final DateTime answeredAt;

  const QuizAnswer({
    required this.questionId,
    required this.selectedAnswerId,
    required this.isCorrect,
    required this.answeredAt,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    return QuizAnswer(
      questionId: json['questionId'] as String,
      selectedAnswerId: json['selectedAnswerId'] as String,
      isCorrect: json['isCorrect'] as bool,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'selectedAnswerId': selectedAnswerId,
      'isCorrect': isCorrect,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [questionId, selectedAnswerId, isCorrect, answeredAt];
}

class Quiz extends Equatable {
  final String quizId;
  final String documentKey;
  final List<QuizQuestion> questions;
  final QuizStatus status;
  final List<QuizAnswer>? answers;
  final DateTime? generatedAt;
  final DateTime? completedAt;
  final int? currentQuestionIndex;
  final ReviewMode? reviewMode;

  const Quiz({
    required this.quizId,
    required this.documentKey,
    required this.questions,
    required this.status,
    this.answers,
    this.generatedAt,
    this.completedAt,
    this.currentQuestionIndex,
    this.reviewMode,
  });

  Quiz copyWith({
    String? quizId,
    String? documentKey,
    List<QuizQuestion>? questions,
    QuizStatus? status,
    List<QuizAnswer>? answers,
    DateTime? generatedAt,
    DateTime? completedAt,
    int? currentQuestionIndex,
    ReviewMode? reviewMode,
  }) {
    return Quiz(
      quizId: quizId ?? this.quizId,
      documentKey: documentKey ?? this.documentKey,
      questions: questions ?? this.questions,
      status: status ?? this.status,
      answers: answers ?? this.answers,
      generatedAt: generatedAt ?? this.generatedAt,
      completedAt: completedAt ?? this.completedAt,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      reviewMode: reviewMode ?? this.reviewMode,
    );
  }

  int get correctAnswersCount {
    if (answers == null) return 0;
    return answers!.where((answer) => answer.isCorrect).length;
  }

  double get scorePercentage {
    if (questions.isEmpty) return 0.0;
    return (correctAnswersCount / questions.length) * 100;
  }

  bool get isCompleted => status == QuizStatus.completed;

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final questionsList = (json['questions'] as List<dynamic>)
        .map((q) => QuizQuestion.fromJson(q as Map<String, dynamic>))
        .toList();
    
    final answersList = json['answers'] != null
        ? (json['answers'] as List<dynamic>)
            .map((a) => QuizAnswer.fromJson(a as Map<String, dynamic>))
            .toList()
        : null;
    
    return Quiz(
      quizId: json['quizId'] as String,
      documentKey: json['documentKey'] as String,
      questions: questionsList,
      status: QuizStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => QuizStatus.ready,
      ),
      answers: answersList,
      generatedAt: json['generatedAt'] != null
          ? DateTime.parse(json['generatedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      currentQuestionIndex: json['currentQuestionIndex'] as int?,
      reviewMode: json['reviewMode'] != null
          ? ReviewMode.values.firstWhere(
              (e) => e.name == json['reviewMode'],
              orElse: () => ReviewMode.overview,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quizId': quizId,
      'documentKey': documentKey,
      'questions': questions.map((q) => q.toJson()).toList(),
      'status': status.name,
      'answers': answers?.map((a) => a.toJson()).toList(),
      'generatedAt': generatedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'currentQuestionIndex': currentQuestionIndex,
      'reviewMode': reviewMode?.name,
    };
  }

  @override
  List<Object?> get props => [
        quizId,
        documentKey,
        questions,
        status,
        answers,
        generatedAt,
        completedAt,
        currentQuestionIndex,
        reviewMode,
      ];
}
