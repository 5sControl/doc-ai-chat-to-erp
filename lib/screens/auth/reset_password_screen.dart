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
    //final TextEditingController passwordController = TextEditingController();
    //final TextEditingController confirmPasswordController =
    //    TextEditingController();
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
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
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
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 56,
                    ),
                    // Text(
                    //   'Reset password',
                    //   maxLines: 2,
                    //   textAlign: TextAlign.start,
                    //   style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 32,
                    //       height: 1.2,
                    //       fontWeight: FontWeight.w700),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Center(
                      child: Text(
                        'We will send you an email\nto reset your password',
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w300),
                      ),
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
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Register Now',
                              style: TextStyle(
                                color: Colors.black,
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

    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            //adding: const MaterialStatePropertyAll(
            //    EdgeInsets.symmetric(vertical: 14)),
            backgroundColor:
                WidgetStatePropertyAll(Theme.of(context).primaryColor)),
        onPressed: onPressConfirm,
        child: Text(
          'Confirm',
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
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
            'Enter your email',
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
          // suffixIcon: IconButton(
          //   icon: Icon(
          //       _passwordVisible ? Icons.visibility : Icons.visibility_off),
          //   onPressed: () {
          //     setState(() {
          //       onPressEye();
          //     });
          //   },
          // ),
          border: OutlineInputBorder(
              gapPadding: 10,
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          floatingLabelStyle: const TextStyle(
              color: Colors.white,
              // height: -2,
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
