import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

// Simple script to generate a demo quiz for "The 7 Habits"
void main() async {
  final summaryText = '''INTRODUCTION
Everyone wants to succeed. But what makes others succeed and others fail? First off, what defines success? While others may find that they have found financial success, they may find that they are empty in other areas of life such as in their relationships or in developing personal effectiveness.
Through studying 200 years of literature, Covey found the concept of success has changed significantly over the years. While success was based on character ethics like integrity, humility, and courage before 1920, success is now based on personality ethics like public image, attitude, and personality. To find true success and see true change, you won't be able to take shortcuts. Instead, you will need to address the underlying conditions and allow yourself to undergo a paradigm shift, change yourself fundamentally and adopt the seven habits of highly effective people.

CHAPTER 1: PRINCIPLES AND PARADIGMS
The 7 habits of highly effective people begins by looking inward and starting from the inside-out. As a society, we attempt to create lives on social media that are aimed to portray happiness and near-perfection. And considering social media is a mere highlight reel of a person's life, we may find ourselves altering our appearances on the outside while struggling internally. Stephen Covey asks his readers to think about what they most value in life, and imagine if everything were taken away tomorrow, what would you desire most? Will social media followers be on that list? Probably not.

CHAPTER 2: HABIT #1 - BE PROACTIVE
Imagine life is just a book with blank pages. If you had the opportunity to write your own story, what would you want it to say? Here's where we have our first principle. The principle of ownership. We can take control of our lives. People who are proactive take action. They take response-ability in their life and assume ownership.

CHAPTER 3: HABIT #2 - BEGIN WITH THE END IN MIND
To begin with the end in mind, you need direction. Just like building a home, a direction is necessary for success. Effective people don't just work hard and expect success to fall upon them, instead, they have a sense of direction in life.

CHAPTER 4: HABIT #3 - PUT FIRST THINGS FIRST
Now that you have determined your values and principles, how can you begin taking action and living by those principles? By incorporating habit 3: Put first things first. By prioritizing and ensuring the most important tasks are done first.

CHAPTER 5: HABIT #4 - THINK WIN-WIN
Life doesn't have to be a competition, both parties can win. By creating a win-win mindset, you can begin to establish successful, interdependent relationships.

CHAPTER 6: HABIT #5 - SEEK FIRST TO UNDERSTAND, THEN TO BE UNDERSTOOD
Whether it's a doctor or a friend, you trust people that understand what you're going through and a key to understanding is through listening. The most effective form of listening is emphatic listening.

CHAPTER 7: HABIT #6 - SYNERGIZE
By understanding and valuing the differences of another's perspective, you create the opportunity for synergy. Synergy is a concept that the combined value of each individual will be greater than if each individual remained independent.

CHAPTER 8: HABIT #7 - SHARPEN THE SAW
Chefs use their knives every day, they constantly chop, slice, and dice eventually making their knife dull. We must devote time to ourselves physically, spiritually, mentally, and socially.''';

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

  print('Generating quiz for "The 7 Habits of Highly Effective People"...');

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
      
      // Add document key
      quizData['documentKey'] = 'The 7 Habits of Highly Effective People';
      
      // Pretty print JSON
      final encoder = JsonEncoder.withIndent('  ');
      final prettyJson = encoder.convert(quizData);
      
      // Save to file
      final file = File('assets/quizzes/the_7_habits_quiz.json');
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
