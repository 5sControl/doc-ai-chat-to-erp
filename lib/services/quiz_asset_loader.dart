import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/models.dart';

class QuizAssetLoader {
  // Map of document keys to their asset file names
  static const Map<String, String> _quizAssets = {
    'The 7 Habits of Highly Effective People': 'the_7_habits_quiz.json',
    'Atomic Habits': 'atomic_habits_quiz.json',
  };

  /// Attempts to load a pre-generated quiz from assets
  /// Returns null if no asset quiz exists for the given documentKey
  static Future<Quiz?> loadDemoQuiz(String documentKey) async {
    try {
      // Check if this document has a pre-generated quiz
      final assetFileName = _quizAssets[documentKey];
      if (assetFileName == null) {
        return null;
      }

      // Load the JSON from assets
      final assetPath = 'assets/quizzes/$assetFileName';
      final jsonString = await rootBundle.loadString(assetPath);
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Parse the quiz data
      final quizId = jsonData['quiz_id'] as String;
      final questionsList = jsonData['questions'] as List<dynamic>;
      final generatedAtStr = jsonData['generated_at'] as String?;

      final questions = questionsList.map((q) {
        final questionData = q as Map<String, dynamic>;
        final optionsList = questionData['options'] as List<dynamic>;

        final options = optionsList.map((opt) {
          final optData = opt as Map<String, dynamic>;
          return QuizOption(
            id: optData['id'] as String,
            text: optData['text'] as String,
          );
        }).toList();

        return QuizQuestion(
          id: questionData['id'] as String,
          question: questionData['question'] as String,
          options: options,
          correctAnswerId: questionData['correct_answer_id'] as String,
          explanation: questionData['explanation'] as String,
        );
      }).toList();

      final generatedAt = generatedAtStr != null
          ? DateTime.parse(generatedAtStr)
          : DateTime.now();

      return Quiz(
        quizId: quizId,
        documentKey: documentKey,
        questions: questions,
        status: QuizStatus.ready,
        generatedAt: generatedAt,
        currentQuestionIndex: 0,
      );
    } catch (e) {
      // If asset not found or any error occurs, return null
      // This allows fallback to API generation
      print('Could not load demo quiz for $documentKey: $e');
      return null;
    }
  }

  /// Check if a document has a pre-generated quiz asset
  static bool hasAssetQuiz(String documentKey) {
    return _quizAssets.containsKey(documentKey);
  }

  /// Get list of all document keys that have pre-generated quizzes
  static List<String> get availableAssetQuizzes {
    return _quizAssets.keys.toList();
  }
}
