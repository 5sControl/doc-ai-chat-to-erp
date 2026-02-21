import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'settings_models.dart';

/// One row for a settings menu item (icon, title, trailing). Used in group screens.
class SettingsListTile extends StatelessWidget {
  final ButtonItem item;
  final bool usePrimaryBackground;

  const SettingsListTile({
    super.key,
    required this.item,
    this.usePrimaryBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = usePrimaryBackground
        ? Theme.of(context).primaryColor
        : Theme.of(context).primaryColor.withOpacity(0);
    final textColor = usePrimaryBackground
        ? Theme.of(context).textTheme.bodySmall!.color
        : null;

    return Material(
      color: bgColor,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: InkWell(
        onTap: item.onTap,
        highlightColor: Colors.white24,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: item.background,
            borderRadius:
                item.background != null
                    ? const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      )
                    : const BorderRadius.all(Radius.circular(8)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SvgPicture.asset(
                  item.leadingIcon,
                  height: 20,
                  colorFilter: ColorFilter.mode(
                    textColor ?? Theme.of(context).textTheme.bodySmall!.color!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  item.title,
                  textAlign: TextAlign.start,
                  style: (textColor != null
                          ? TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )
                          : Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child:
                    item.trailing ??
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: textColor ?? Theme.of(context).textTheme.bodySmall!.color,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
