import 'package:summify/services/demo_data_initializer.dart';

/// Demo chat question and answer for the Atomic Habits summary.
/// Used to show a pre-filled answer with a Mermaid diagram so users can
/// try the diagram viewer without calling the API.
class DemoResearch {
  /// Same key as the demo summary (Atomic Habits).
  static const String demoKey = DemoDataInitializer.demoKey;

  static const String demoQuestion =
      'How do the Four Laws of Behavior Change work? Show a diagram.';

  static const String demoAnswer = '''
In **Atomic Habits**, James Clear describes the Four Laws of Behavior Change that make habits stick:

1. **Make it Obvious** (Cue) — design your environment so the cue is visible.
2. **Make it Attractive** (Craving) — pair the habit with something you want.
3. **Make it Easy** (Response) — reduce friction; use the Two-Minute Rule.
4. **Make it Satisfying** (Reward) — track progress and reward immediately.

Here is a diagram of the flow:

```mermaid
flowchart LR
  A[Obvious] --> B[Attractive]
  B --> C[Easy]
  C --> D[Satisfying]
```

Tap the diagram above to open it in full screen. You can zoom and scroll to explore.
''';
}
