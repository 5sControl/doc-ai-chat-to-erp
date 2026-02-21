import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import 'groups/settings_groups_config.dart';
import 'settings_group_tile.dart';
import 'settings_models.dart';
import 'widgets/profile_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (_, current) => current is AuthenticationSuccessState,
      listener: (context, state) {
        context.read<SubscriptionsBloc>().add(const GetSubscriptionStatus());
      },
      builder: (context, state) {
        return Stack(
          children: [
            const BackgroundGradient(),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                title: Text(l10n.settings_profile),
              ),
              body: Container(
                height: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    final isSignedIn = snapshot.hasData &&
                        snapshot.connectionState != ConnectionState.waiting;
                    final entries = getSettingsGroupEntries(context, isSignedIn: isSignedIn);

                    return SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const ProfileHeader(),
                          const SizedBox(height: 15),
                          ...entries.map(
                            (entry) => SettingsGroupTile(
                              title: entry.title,
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  '/settings/group',
                                  arguments: SettingsGroupArgs(
                                    id: entry.id,
                                    title: entry.title,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'version 1.6.1',
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(height: 1),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
