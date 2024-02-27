import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/authentication/authentication_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Account',
          ),
        ),
        body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authState) {
            final user =
                authState is AuthenticationSuccessState ? authState.user : null;
            print(user);
            return Container(
              child: Text(user?.email ?? ''),
            );
          },
        ));
  }
}
