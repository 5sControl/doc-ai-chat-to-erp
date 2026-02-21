import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_bloc.dart';

class ThemeButtons extends StatefulWidget {
  const ThemeButtons({super.key});

  @override
  State<ThemeButtons> createState() => _ThemeButtonsState();
}

class _ThemeItem {
  final String title;
  final AppTheme appTheme;
  _ThemeItem({required this.title, required this.appTheme});
}

class _ThemeButtonsState extends State<ThemeButtons> {
  final List<_ThemeItem> themeItems = [
    _ThemeItem(title: 'Auto', appTheme: AppTheme.auto),
    _ThemeItem(title: 'On', appTheme: AppTheme.dark),
    _ThemeItem(title: 'Off', appTheme: AppTheme.light),
  ];

  void onSelectTheme({required AppTheme appTheme}) {
    context.read<SettingsBloc>().add(SelectAppTheme(appTheme: appTheme));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children:
                themeItems
                    .map(
                      (themeItem) => Container(
                        width: 50,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color:
                              themeItem.appTheme == state.appTheme
                                  ? Theme.of(context).highlightColor
                                  : Colors.white24,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: InkWell(
                          onTap:
                              () => onSelectTheme(appTheme: themeItem.appTheme),
                          child: Text(
                            themeItem.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  themeItem.appTheme == state.appTheme
                                      ? Colors.white
                                      : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }
}
