import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_bloc.dart';

class NotificationsSwitch extends StatelessWidget {
  const NotificationsSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    void onTapNotifications() {
      context.read<SettingsBloc>().add(const ToggleNotifications());
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return SizedBox(
          height: 20,
          child: Transform.scale(
            scale: 0.9,
            child: Switch(
              inactiveThumbColor: Colors.grey.shade500,
              trackOutlineColor: MaterialStatePropertyAll(
                Theme.of(context).highlightColor,
              ),
              activeColor: Theme.of(context).highlightColor,
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: state.isNotificationsEnabled,
              onChanged: (_) => onTapNotifications(),
            ),
          ),
        );
      },
    );
  }
}
