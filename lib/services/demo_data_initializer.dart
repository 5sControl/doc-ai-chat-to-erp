import 'package:summify/bloc/library/books/atomic_habits.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/models/models.dart';

/// Service for creating demo data
class DemoDataInitializer {
  static const String demoKey = 'Atomic Habits (Rephrase)';

  /// Creates the demo summary data with all required fields including original text
  static SummaryData createDemoSummary() {
    return SummaryData(
      shortSummaryStatus: SummaryStatus.complete,
      longSummaryStatus: SummaryStatus.complete,
      date: DateTime.now(),
      summaryPreview: SummaryPreview(
        title: 'Atomic Habits (Rephrase)',
        imageUrl: Assets.library.atomicHabitsRephrase.path,
      ),
      summaryOrigin: SummaryOrigin.text,
      userText: atomicHabitsSummary,
      shortSummary: const Summary(
        summaryText:
            'Summary:\nAtomic Habits Core Concepts\n\nTiny, incremental changes compound into remarkable results over time. The key is building identity-based systems, not focusing on goals.\n\nKey Points:\nThe Four Laws of Behavior Change:\n1. Make it Obvious - Use habit stacking and environmental design\n2. Make it Attractive - Use temptation bundling and positive reframing\n3. Make it Easy - Follow the Two-Minute Rule, reduce friction\n4. Make it Satisfying - Track progress, reward immediately\n\nKey Principles:\n- Focus on systems, not goals\n- Every action is a vote for your identity\n- Results lag behind habits (Plateau of Latent Potential)\n- You don\'t rise to your goals, you fall to your systems\n\nIn-depth Analysis:\nThe Two-Minute Rule: Downscale any habit to take two minutes or less. "Go for a run" becomes "put on running shoes." Master showing up first.\n\nAdditional Context:\nWhat is rewarded is repeated. What is punished is avoided.',
      ),
      longSummary: const Summary(
        summaryText:
            "Summary:\nCore Idea:\nTiny, incremental changes (atomic habits) compound into remarkable results over time. Focus not on goals, but on building identity-based systems.\n\nKey Points:\nThe Four Laws of Behavior Change (The Framework for Good Habits):\n\nTo build a good habit, make it:\n\n1. Obvious (Cue): Make the cue for your habit visible.\n- Strategy: Use \"Habit Stacking\": \"After [CURRENT HABIT], I will [NEW HABIT].\" (e.g., \"After I pour my morning coffee, I will write one sentence in my journal.\")\n- Strategy: Design your environment. Place visual cues where you\'ll see them (e.g., put your running shoes by the door).\n\n2. Attractive (Craving): Make the habit appealing.\n- Strategy: Use \"Temptation Bundling.\" Pair something you want to do with something you need to do. (e.g., \"Only listen to my favorite podcast while at the gym.\")\n- Strategy: Reframe your mindset. Focus on the benefits and positive feelings the habit will bring.\n\n3. Easy (Response): Reduce friction. Make the habit simple to start.\n- Strategy: The Two-Minute Rule. Downscale any new habit to take two minutes or less to do. (\"Go for a run\" becomes \"put on running shoes.\") Master the art of showing up.\n- Strategy: Optimize your environment to make the easiest choice the right one (e.g., prepare a healthy lunch the night before).\n\n4. Satisfying (Reward): Make it immediately rewarding.\n- Strategy: Use immediate reinforcement. Track your habit on a calendar (don\'t break the chain!) or give yourself a small, healthy reward.\n- The Cardinal Rule: What is rewarded is repeated. What is punished is avoided.\n\nIn-depth Analysis:\nKey Supporting Concepts:\n- Forget goals, focus on systems. Goals are about results you want; systems are about the processes that lead to those results. You don\'t rise to the level of your goals, you fall to the level of your systems.\n- Identity change is the North Star. The ultimate form of intrinsic motivation is when a habit becomes part of your identity. Shift from \"I want to run\" to \"I am a runner.\" Every small action is a vote for that new identity.\n- The Plateau of Latent Potential (The Valley of Disappointment). Results often lag behind habits. Trust the compounding process. Breakthroughs happen after pushing through this plateau.\n\nAdditional Context:\nIn a Nutshell:\nTo build a good habit, use the Four Laws: Make it obvious, attractive, easy, and satisfying. Start extremely small, focus on consistent repetition, and design your environment to make the right behaviors effortless. Your habits shape your identity, and your identity shapes your habits.",
      ),
    );
  }
}
