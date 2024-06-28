import 'package:summify/bloc/library/books/13_things.dart';
import 'package:summify/bloc/library/books/atomic_habits.dart';
import 'package:summify/bloc/library/books/designingYourLife.dart';
import 'package:summify/bloc/library/books/doTheWork.dart';
import 'package:summify/bloc/library/books/extreme_productivity.dart';
import 'package:summify/bloc/library/books/gettingComfy.dart';
import 'package:summify/bloc/library/books/goodVibes.dart';
import 'package:summify/bloc/library/books/howSuccessful.dart';
import 'package:summify/bloc/library/books/howToBe.dart';
import 'package:summify/bloc/library/books/learnOrDie.dart';
import 'package:summify/bloc/library/books/maximizeYourPotential.dart';
import 'package:summify/bloc/library/books/not_giving_a_fuck.dart';
import 'package:summify/bloc/library/books/startSomethingThatMatters.dart';
import 'package:summify/bloc/library/books/successAndLuck.dart';
import 'package:summify/bloc/library/books/theCharge.dart';
import 'package:summify/bloc/library/books/the_7_habits.dart';
import 'package:summify/bloc/library/books/unlimited_memory.dart';
import 'package:summify/bloc/library/books/whatColorIs.dart';
import 'package:summify/bloc/library/books/whatGotYouHere.dart';
import 'package:summify/bloc/library/books/whereverYouGo.dart';
import 'package:summify/bloc/library/books/worksWellWithOthers.dart';

import '../../models/models.dart';

const Map<String, LibraryDocument> libraryDocuments = {
  'Atomic Habits': LibraryDocument(
      title: 'Atomic Habits',
      annotation: atomicHabitsAnnotation,
      summary: atomicHabitsSummary,
      img: 'assets/library/atomicHabits.jpeg'),
  'Extreme Productivity': LibraryDocument(
      title: 'Extreme Productivity',
      annotation: extremeProductivityAnnotation,
      summary: extremeProductivitySummary,
      img: 'assets/library/extremeProductivity.jpeg'),
  'Do the Work': LibraryDocument(
      title: 'Do the Work',
      annotation: doTheWorkAnnotation,
      summary: doTheWorkSummary,
      img: 'assets/library/doTheWork.jpeg'),
  '13 Things Mentally Strong People Don’t Do': LibraryDocument(
      title: '13 Things Mentally Strong People Don’t Do',
      annotation: a13ThingsAnnotation,
      summary: a13ThingsSummary,
      img: 'assets/library/a13Things.jpeg'),
  'The Subtle Art of Not Giving a F*ck': LibraryDocument(
      title: 'The Subtle Art of Not Giving a F*ck',
      annotation: notGivingAFuckAnnotation,
      summary: notGivingAFuckSummary,
      img: 'assets/library/notGivingAFuck.jpeg'),
  'Unlimited Memory': LibraryDocument(
      title: 'Unlimited Memory',
      annotation: unlimitedMemoryAnnotation,
      summary: unlimitedMemorySummary,
      img: 'assets/library/unlimited_memory.jpeg'),
  'The 7 Habits of Highly Effective People': LibraryDocument(
      title: 'The 7 Habits of Highly Effective People',
      annotation: the7HabitsAnnotation,
      summary: the7HabitsSummary,
      img: 'assets/library/the7Habits.jpeg'),
  'Getting COMFY': LibraryDocument(
      title: 'Getting COMFY',
      annotation: gettingComfyAnnotation,
      summary: gettingComfySummary,
      img: 'assets/library/gettingComfy.jpeg'),
  'Designing Your Life': LibraryDocument(
      title: 'Designing Your Life',
      annotation: designingYourLifeAnnotation,
      summary: designingYourLifeSummary,
      img: 'assets/library/designingYourLife.jpeg'),
  'How Successful People Think': LibraryDocument(
      title: 'How Successful People Think',
      annotation: howSuccessfulAnnotation,
      summary: howSuccessfulSummary,
      img: 'assets/library/howSuccessful.jpeg'),
  'Maximize Your Potential': LibraryDocument(
      title: 'Maximize Your Potential',
      annotation: maximizeYourPotentialAnnotation,
      summary: maximizeYourPotentialSummary,
      img: 'assets/library/maximizeYourPotential.jpeg'),
  'Success and Luck': LibraryDocument(
      title: 'Success and Luck',
      annotation: successAndLuckAnnotation,
      summary: successAndLuckSummary,
      img: 'assets/library/successAndLuck.jpeg'),
  'Works Well With Others': LibraryDocument(
      title: 'Works Well With Others',
      annotation: worksWellWithOthersAnnotation,
      summary: worksWellWithOthersSummary,
      img: 'assets/library/worksWellWithOthers.jpeg'),
  'What Color is Your Parachute?': LibraryDocument(
      title: 'What Color is Your Parachute?',
      annotation: whatColorIsAnnotation,
      summary: whatColorIsSummary,
      img: 'assets/library/whatColorIs.jpeg'),
  'What Got You Here, Won’t Get You There': LibraryDocument(
      title: 'What Got You Here, Won’t Get You There',
      annotation: whatGotYouHereAnnotation,
      summary: whatGotYouHereSummary,
      img: 'assets/library/whatGotYouHere.jpeg'),
  'Learn or Die': LibraryDocument(
      title: 'Learn or Die',
      annotation: learnOrDieAnnotation,
      summary: learnOrDieSummary,
      img: 'assets/library/learnOrDie.jpeg'),
  'How to Be a Power Connector': LibraryDocument(
      title: 'How to Be a Power Connector',
      annotation: howToBeAnnotation,
      summary: howSuccessfulSummary,
      img: 'assets/library/howToBe.jpeg'),
  'Start Something That Matters': LibraryDocument(
      title: 'Start Something That Matters',
      annotation: startSomethingThatMattersAnnotation,
      summary: startSomethingThatMattersSummary,
      img: 'assets/library/startSomethingThatMatters.jpeg'),
  'The Charge': LibraryDocument(
      title: 'The Charge',
      annotation: theChargeAnnotation,
      summary: theChargeString,
      img: 'assets/library/theCharge.jpeg'),
  'Good Vibes, Good Life': LibraryDocument(
      title: 'Good Vibes, Good Life',
      annotation: goodVibesAnnotation,
      summary: goodVibesSummary,
      img: 'assets/library/goodVibes.jpeg'),
  'Wherever You Go, There You Are': LibraryDocument(
      title: 'Wherever You Go, There You Are',
      annotation: whereverYouGoAnnotation,
      summary: whereverYouGoSummary,
      img: 'assets/library/whereverYouGo.jpeg'),
};
