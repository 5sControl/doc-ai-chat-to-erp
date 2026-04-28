import 'package:firebase_analytics/firebase_analytics.dart';

/// Logs a custom GA4 event for summary document tab usage (aligned with Mixpanel `summary_type`).
Future<void> logSummaryTabView({
  required String tab,
  String screenContext = 'summary',
  String? abVariant,
}) async {
  try {
    await FirebaseAnalytics.instance.logEvent(
      name: 'summary_tab_view',
      parameters: {
        'tab': tab,
        'screen_context': screenContext,
        if (abVariant != null && abVariant.isNotEmpty) 'ab_variant': abVariant,
      },
    );
  } catch (_) {}
}
