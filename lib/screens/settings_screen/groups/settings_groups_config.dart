import 'package:flutter/material.dart';
import 'package:summify/l10n/app_localizations.dart';

import '../settings_models.dart';
import 'account_group.dart';
import 'about_group.dart';
import 'general_group.dart';
import 'subscription_group.dart';
import 'support_group.dart';
import 'voice_group.dart';

/// Metadata for one group shown on the settings root screen.
class SettingsGroupEntry {
  final SettingsGroupId id;
  final String title;

  const SettingsGroupEntry({required this.id, required this.title});
}

/// Returns the list of group entries to show on the root settings screen.
/// Pass [context] for localized titles; [isSignedIn] from Firebase auth state.
/// When true, Account is inserted before Voice.
List<SettingsGroupEntry> getSettingsGroupEntries(
  BuildContext context, {
  required bool isSignedIn,
}) {
  final l10n = AppLocalizations.of(context);
  final baseEntries = [
    SettingsGroupEntry(id: SettingsGroupId.subscription, title: l10n.settings_group_subscription),
    SettingsGroupEntry(id: SettingsGroupId.general, title: l10n.settings_general),
    SettingsGroupEntry(id: SettingsGroupId.about, title: l10n.settings_group_about),
    SettingsGroupEntry(id: SettingsGroupId.support, title: l10n.settings_group_support),
    SettingsGroupEntry(id: SettingsGroupId.voice, title: l10n.settings_group_voice),
  ];
  if (!isSignedIn) return baseEntries;
  final list = List<SettingsGroupEntry>.from(baseEntries);
  list.insert(list.length - 1, SettingsGroupEntry(id: SettingsGroupId.account, title: l10n.settings_group_account));
  return list;
}

/// Returns the menu items for a given group. Call from the group screen's build with that screen's context.
List<ButtonItem> getItemsForGroup(BuildContext context, SettingsGroupId id) {
  switch (id) {
    case SettingsGroupId.subscription:
      return buildSubscriptionGroupItems(context);
    case SettingsGroupId.general:
      return buildGeneralGroupItems(context);
    case SettingsGroupId.about:
      return buildAboutGroupItems(context);
    case SettingsGroupId.support:
      return buildSupportGroupItems(context);
    case SettingsGroupId.account:
      return buildAccountGroupItems(context);
    case SettingsGroupId.voice:
      return buildVoiceGroupItems(context);
  }
}
