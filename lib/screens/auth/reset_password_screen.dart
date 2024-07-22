// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/authentication/authentication_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

    void onPressSignUp() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignInUserWithEmail(
          passwordController.text.trim(),
          confirmPasswordController.text.trim(),
        ),
      );
    }

    return Stack(children: [
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
        body: Stack(
          children: [Container(
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
                    Text(
                      'Reset password',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          height: 1.2,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Enter your new password',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          height: 1.2,
                          fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 25,)
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
                    PasswordInput(controller: passwordController),
                    const Divider(
                      color: Colors.transparent,
                      height: 20,
                    ),
                    ConfirmPasswordInput(controller: confirmPasswordController),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                
                SignUpButton(
                  onPress: onPressSignUp,
                ),
                
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
                                ..onTap = () {
                                  print('Register');
                                })
                        ]),
                  ),
                )
              ],
            ),
          ),
    
          ]
        ),
      ),
    ]);
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
    return TextField(
      //textAlignVertical: TextAlignVertical.top,
      cursorWidth: 3,
      cursorColor: Colors.black54,
      cursorHeight: 20,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: widget.controller,
      obscureText: !_passwordVisible,
      enableSuggestions: false,
      autocorrect: false,
      decoration: InputDecoration(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(
            'Password',
            style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall!.color,
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                onPressEye();
              });
            },
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
    return TextField(
      //textAlignVertical: TextAlignVertical.top,
      cursorWidth: 3,
      cursorColor: Colors.black54,
      cursorHeight: 20,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      controller: widget.controller,
      obscureText: !_passwordVisible,
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
          suffixIcon: IconButton(
            icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                onPressEye();
              });
            },
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

class SignUpButton extends StatelessWidget {
  final VoidCallback onPress;
  const SignUpButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        showDialog(
          context: context, 
          builder: (BuildContext context) { 
            return AlertDialog(
              title: Center(child: Text('Password changed')),
              content: Text('You can log in with new password'),
              actions: [
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('Log in'))
              ],
            );
           }
                
        );
      },
      child: Container(
        alignment: Alignment.center,
        // height: 50,
        padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.teal.shade300,
            borderRadius: BorderRadius.circular(8)),
        child: const Text(
          'Login in',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}