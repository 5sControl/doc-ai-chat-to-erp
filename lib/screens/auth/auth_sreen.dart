import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void onPressSignUp() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignInUserWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        ),
      );
    }

    void onPressSignOut() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignOut(),
      );
    }

    void onPressGoogle() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignInUserWithGoogle(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'SummiShare for iPhone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            const Text(
              'Sign up a free account',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
            ),
            const Divider(
              color: Colors.transparent,
              height: 20,
            ),
            EmailInput(controller: emailController),
            const Divider(
              color: Colors.transparent,
              height: 15,
            ),
            PasswordInput(controller: passwordController),
            const Divider(
              color: Colors.transparent,
              height: 50,
            ),
            SignUpButton(
              onPress: onPressSignUp,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Already have an account? Sign in',
                textAlign: TextAlign.center,
              ),
            ),
            const DividerRow(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: onPressGoogle,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const Icon(Icons.g_mobiledata),
                  ),
                ),
                InkWell(
                  // onTap: onPressGoogle,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: const Icon(Icons.apple),
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'By using this app, you agree to the Terms and Conditions and Privacy Policy ',
                textAlign: TextAlign.center,
              ),
            ),
            IconButton(
                onPressed: onPressSignOut,
                icon: Icon(Icons.follow_the_signs_outlined))
          ],
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
            labelText: 'Email', border: OutlineInputBorder()),
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  const PasswordInput({super.key, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  void onPressEye() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextField(
        controller: widget.controller,
        obscureText: !_passwordVisible,
        enableSuggestions: false,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: 'Password',
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
            onPressed: onPressEye,
          ),
        ),
      ),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final VoidCallback onPress;
  const SignUpButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        alignment: Alignment.center,
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 12),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.teal, borderRadius: BorderRadius.circular(8)),
        child: const Text(
          'Sign up',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  const DividerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // width: 20,
              height: 1,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text('OR'),
          ),
          Expanded(
            child: Container(
              // width: 20,
              height: 1,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
