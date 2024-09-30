// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/helpers/show_error_toast.dart';
import 'package:summify/helpers/show_success_toast.dart';
import 'package:summify/screens/auth/auth_dialog.dart';
import 'package:summify/screens/auth/registration_screen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/authentication/authentication_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController emailController = TextEditingController();

  @override
    void dispose() {
      emailController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    void onPressRegister() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const RegistrationScreen();
        },
      ));
    }
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is RestorePasswordSuccess) {
          showSuccessToast(context: context, title: 'Email sent');
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop();
          });
        }
        if (state is RestorePasswordError) {
          showErrorToast(context: context, error: state.errorMessage);
        }
      },
      child: Stack(children: [
      const BackgroundGradient(),
      Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 24,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(children: [
          Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 18),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              //mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  //mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 56,
                    ),
                    Text(
                      'We will send you an email\nto reset your password',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 30,
                          height: 1.2,
                          fontWeight: FontWeight.w700)
                    ),
                    SizedBox(
                      height: 25,
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(
                      color: Colors.transparent,
                      height: 20,
                    ),
                    PasswordInput(controller: emailController),
                    
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ConfirmButton(controller: emailController),
                Expanded(child: Container()),
                Center(
                  child: RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 15),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Register Now',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = onPressRegister)
                        ]),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    ])
    );
  }
}

class ConfirmButton extends StatelessWidget {
  final TextEditingController controller;
  const ConfirmButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    void onPressConfirm() {
      context
          .read<AuthenticationBloc>()
          .add(SendResetEmail(email: controller.text));
    }

    return InkWell(
      onTap: onPressConfirm,
      child: Container(
        alignment: Alignment.center,
         height: 50,
        //padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 186, 195, 1),
            borderRadius: BorderRadius.circular(8)),
        child: const Text(
          'Confirm',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
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

  @override
  Widget build(BuildContext context) {
    return TextField(
      //textAlignVertical: TextAlignVertical.top,
      cursorWidth: 3,
      cursorColor: Colors.black54,
      cursorHeight: 20,
      style: const TextStyle(color: Colors.black,fontSize: 18),
      controller: widget.controller,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: const Text(
            'Enter your email',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400),
          ),
          border: OutlineInputBorder(
              gapPadding: 10,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          floatingLabelStyle: const TextStyle(
              color: Colors.black,
              // height: -2,
              fontSize: 18,
              fontWeight: FontWeight.w500)),
    );
  }
}

class ConfirmPasswordInput extends StatefulWidget {
  final TextEditingController controller;
  const ConfirmPasswordInput({super.key, required this.controller});

  @override
  State<ConfirmPasswordInput> createState() => _ConfirmPasswordInputState();
}

class _ConfirmPasswordInputState extends State<ConfirmPasswordInput> {

  @override
  Widget build(BuildContext context) {
    return TextField(
      //textAlignVertical: TextAlignVertical.top,
      cursorWidth: 3,
      cursorColor: Colors.black54,
      cursorHeight: 20,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: widget.controller,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(
            'Confirm password',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall!.color,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          border: OutlineInputBorder(
              gapPadding: 10,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          floatingLabelStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500)),
    );
  }
}

class SignUpButton extends StatelessWidget {
  final VoidCallback onPress;
  const SignUpButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return AuthDialog(
      title: 'Password changed',
      subTitle: 'You can log in with\nnew password',
      textButton: 'Log in',
      onTap: () {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      },
    );
  }
}
