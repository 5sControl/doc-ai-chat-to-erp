import 'package:flutter/material.dart';

import 'groups/settings_groups_config.dart';
import 'settings_list_tile.dart';
import 'settings_models.dart';

class SettingsGroupScreen extends StatelessWidget {
  final SettingsGroupId groupId;
  final String title;

  const SettingsGroupScreen({
    super.key,
    required this.groupId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final items = getItemsForGroup(context, groupId);
    final usePrimaryBackground = groupId == SettingsGroupId.subscription;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        children: [
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: Text('No options available')),
            )
          else
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                color: usePrimaryBackground
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    SettingsListTile(
                      item: items[i],
                      usePrimaryBackground: usePrimaryBackground,
                    ),
                    if (i < items.length - 1)
                      Divider(
                        height: 1,
                        color: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .color!
                            .withOpacity(0.5),
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
