// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/screens/settings_screen/settings_screen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

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
    //
    // void onPressSignOut() {
    //   BlocProvider.of<AuthenticationBloc>(context).add(
    //     SignOut(),
    //   );
    // }

    void onPressGoogle() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignInUserWithGoogle(),
      );
    }

    void onPressApple() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignInUserWithApple(),
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
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ))
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 18),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'Hello!',
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        height: 1.2,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Fill in to get started',
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        height: 1.2,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(
                    color: Colors.transparent,
                    height: 20,
                  ),
                  EmailInput(controller: emailController),
                  const Divider(
                    color: Colors.transparent,
                    height: 20,
                  ),
                  PasswordInput(controller: passwordController),
                ],
              ),
              const SizedBox(height: 20,),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(height: 20,),
              SignUpButton(
                onPress: onPressSignUp,
              ),
              // const SizedBox(
              //   width: double.infinity,
              //   child: Text(
              //     'Already have an account? Sign in',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              const SizedBox(height: 20,),
              const DividerRow(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [
                    InkWell(
                      onTap: onPressGoogle,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 30, top: 10, right: 30, bottom: 10),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(234, 245, 246, 0.298),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: SvgPicture.asset('assets/icons/google.svg'),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    InkWell(
                      onTap: onPressApple,
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 30, top: 10, right: 30, bottom: 10),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(234, 245, 246, 0.298),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: SvgPicture.asset('assets/icons/apple.svg', color: Colors.black,),
                      ),
                    ),
                  ],)
                  
                ],
              ),
              Expanded(
                child: Container()
              ),
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
                          ..onTap = (){
                            print('Register');
                          }
                      )
                    ]
                  ),
                ),
              )
              // const SizedBox(
              //   width: double.infinity,
              //   child: Text(
              //     'Don\'t have an account?',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ]);
  }
}

class EmailInput extends StatelessWidget {
  final TextEditingController controller;
  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.top,
      controller: controller,
      cursorWidth: 3,
      cursorColor: Colors.black54,
      cursorHeight: 20,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: Text(
            'Email Address',
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

class SignUpButton extends StatelessWidget {
  final VoidCallback onPress;
  const SignUpButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
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

class DividerRow extends StatelessWidget {
  const DividerRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              // width: 20,
              height: 2,
              color: Colors.black,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Or Login with',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          Expanded(
            child: Container(
              // width: 20,
              height: 2,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
