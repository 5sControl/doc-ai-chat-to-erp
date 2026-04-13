import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/screens/auth/auth_screen.dart';
import 'package:summify/screens/auth/registration_screen.dart';
import 'package:summify/widgets/themed_alert_dialog.dart';

bool isAuthenticated(BuildContext context) {
  return context.read<AuthenticationBloc>().state
      is AuthenticationSuccessState;
}

/// Returns `true` if the user is already authenticated.
/// Otherwise shows an auth gate dialog and returns `false`.
bool requireAuth(BuildContext context) {
  if (isAuthenticated(context)) return true;
  showAuthGateDialog(context);
  return false;
}

void showAuthGateDialog(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  showDialog(
    context: context,
    builder: (dialogContext) {
      final theme = Theme.of(dialogContext);
      return AppThemedAlertDialog.build(
        context: dialogContext,
        title: Text(
          l10n.auth_gate_title,
          textAlign: TextAlign.center,
          style: AppThemedAlertDialog.titleTextStyle(theme),
        ),
        content: Text(
          l10n.auth_gate_description,
          textAlign: TextAlign.center,
          style: AppThemedAlertDialog.contentTextStyle(theme),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppThemedAlertDialog.primaryFilled(
                context: dialogContext,
                label: l10n.auth_gate_signUp,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegistrationScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              AppThemedAlertDialog.secondaryAction(
                context: dialogContext,
                label: l10n.auth_gate_logIn,
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AuthScreen(hideSkip: true),
                    ),
                  );
                },
              ),
              AppThemedAlertDialog.secondaryAction(
                context: dialogContext,
                label: l10n.auth_gate_cancel,
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ],
      );
    },
  );
}
