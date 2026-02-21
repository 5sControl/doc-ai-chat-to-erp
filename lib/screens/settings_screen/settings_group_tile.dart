import 'package:flutter/material.dart';

/// One tappable row on the root settings screen: group title + arrow. Navigates to group screen.
class SettingsGroupTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsGroupTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.2),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          highlightColor: Colors.white24,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
