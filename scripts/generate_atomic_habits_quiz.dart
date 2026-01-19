import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

// Script to generate quiz for Atomic Habits demo content
void main() async {
  final summaryText = '''Core Idea:
Tiny, incremental changes (atomic habits) compound into remarkable results over time. Focus not on goals, but on building identity-based systems.

The Four Laws of Behavior Change:
To build a good habit, make it:

1. Obvious (Cue): Make the cue for your habit visible.
Strategy: Use "Habit Stacking" and design your environment with visual cues.

2. Attractive (Craving): Make the habit appealing.
Strategy: Use "Temptation Bundling" and reframe your mindset positively.

3. Easy (Response): Reduce friction. Make the habit simple to start.
Strategy: The Two-Minute Rule - downscale any habit to take two minutes or less. Master showing up first.

4. Satisfying (Reward): Make it immediately rewarding.
Strategy: Track your progress and reward yourself. What is rewarded is repeated.

Key Concepts:
- Focus on systems, not goals
- Identity change is the North Star - every action is a vote for your identity
- Results lag behind habits (Plateau of Latent Potential)
- You fall to the level of your systems, not rise to your goals
''';

  const apiKey = 'acf8421909af3940f4731f629e28ca486c9ed6af7d7f704a050494773a27c8a9';
  const generateQuizUrl = 'https://employees-training.com/api/v1/quizzes/generate';

  final dio = Dio(
    BaseOptions(
      responseType: ResponseType.plain,
      headers: {
        'X-API-Key': apiKey,
      },
    ),
  );

  print('Generating quiz for "Atomic Habits" demo content...');

  try {
    final response = await dio.post(
      generateQuizUrl,
      data: {
        'text': summaryText,
        'num_questions': 5,
        'difficulty': 'medium',
      },
    );

    if (response.statusCode == 200) {
      final quizData = jsonDecode(response.data) as Map<String, dynamic>;
      
      // Update with correct document key
      quizData['quiz_id'] = 'demo_atomic_habits';
      quizData['documentKey'] = 'Atomic Habits';
      
      // Pretty print JSON
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(quizData);
      
      // Save to file
      final file = File('assets/quizzes/atomic_habits_quiz.json');
      await file.writeAsString(prettyJson);
      
      print('✓ Quiz generated successfully!');
      print('✓ Saved to: ${file.path}');
      print('\nQuiz contains ${(quizData['questions'] as List).length} questions');
    } else {
      print('✗ Failed to generate quiz. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('✗ Error generating quiz: $e');
  }
}
