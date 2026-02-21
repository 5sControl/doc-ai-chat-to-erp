import 'package:flutter/material.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/screens/settings_screen/auth_dialog_helper.dart';
import 'package:summify/screens/settings_screen/settings_models.dart';

List<ButtonItem> buildAccountGroupItems(BuildContext context) {
  return [
    ButtonItem(
      title: 'Log out',
      leadingIcon: Assets.icons.logout,
      onTap: () {
        showAuthDialog(
          context,
          title: 'Are you sure you\nwant to log out?',
          subTitle: 'Come back soon, we\'ll be\nwaiting for you!',
          confirmButtonText: 'Yes, log out',
        );
      },
    ),
    ButtonItem(
      title: 'Delete account',
      leadingIcon: Assets.icons.deleteAccount,
      onTap: () {
        showAuthDialog(
          context,
          title: 'Are you sure that you\nwant to delete your account?',
          subTitle:
              'Please note that all your documents will\nalso be deleted!',
          confirmButtonText: 'Yes, delete',
        );
      },
    ),
  ];
}
