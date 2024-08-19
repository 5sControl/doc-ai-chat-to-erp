// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/helpers/show_error_toast.dart';
import 'package:summify/helpers/show_success_toast.dart';
import 'package:summify/screens/auth/registration_screen.dart';
import 'package:summify/screens/auth/reset_password_screen.dart';
import 'package:summify/screens/settings_screen/settings_screen.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../../bloc/authentication/authentication_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String email = '';
    String password = '';


  @override
  void initState() {
    emailController.addListener(() {
      setState(() {
        email = emailController.text;
      });
    });

    passwordController.addListener(() {
      setState(() {
        password = passwordController.text;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    void onPressLogin() {
      if (email.isNotEmpty && password.isNotEmpty) {
        context
            .read<AuthenticationBloc>()
            .add(SignInUserWithEmail(email: email, password: password));
      }
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

    void onPressApple() {
      BlocProvider.of<AuthenticationBloc>(context).add(
        SignInUserWithApple(),
      );
    }

    void onPressRegister() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const RegistrationScreen();
        },
      ));
    }

    void onPressForgot() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return const ResetPasswordScreen();
        },
      ));
    }

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state){
        if (state is AuthenticationSuccessState) {
          //showSuccessToast(context: context, title: 'Successfully logged in');
          //Future.delayed(const Duration(milliseconds: 100), () {
          //context.read<SubscriptionsBloc>().add(const GetSubscriptionStatus());
          Navigator.of(context).pushNamed(
            '/');
          //});
        }

        if (state is AuthenticationFailureState) {
          showErrorToast(context: context, error: state.errorMessage);
        }
      },
      builder: (context, state){
      return Stack(children: [
        const BackgroundGradient(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                
                size: 24,
              ),
              onPressed: (){Navigator.of(context).pop();}
            ),
            
            actions: [
              TextButton(
                  onPressed: () {Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
              },
                  child: Text(
                    'Skip',
                    style: TextStyle(fontSize: 16, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
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
                          fontSize: 30,
                          height: 1.2,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Fill in to get started',
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 30,
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
                InkWell(
                  onTap: onPressForgot,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                SignUpButton(
                  onPress: onPressLogin,
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
                          decoration: const BoxDecoration(
                              color: Color.fromRGBO(234, 245, 246, 0.298),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: SvgPicture.asset('assets/icons/google.svg'),
                        ),
                      ),
                      const SizedBox(width: 20,),
                      InkWell(
                        onTap: onPressApple,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 30, top: 10, right: 30, bottom: 10),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(234, 245, 246, 0.298),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
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
                      style: TextStyle( color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register Now',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = 
                              onPressRegister
                            
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
        AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              reverseDuration: const Duration(milliseconds: 800),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Builder(
                builder: (context) {
                  if (state is AuthenticationLoadingState) {
                    return BackdropFilter(
                      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                      child: Container(),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
      ]
      );
      }
    );
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
      cursorHeight: 20,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      decoration: InputDecoration(
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          floatingLabelAlignment: FloatingLabelAlignment.start,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          label: const Text(
            'Email Address',
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    // Add more validation criteria if needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //textAlignVertical: TextAlignVertical.top,
      cursorWidth: 3,
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
          label: const Text(
            'Password',
            style: TextStyle(
                color: Colors.black,
                fontSize: 14,
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
              // height: -2,
              fontSize: 18,
              fontWeight: FontWeight.w500)),
              validator: _validatePassword,
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
            color: const Color.fromRGBO(0, 186, 195, 1),
            borderRadius: BorderRadius.circular(8)),
        child: const Text(
          'Login in',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
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
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
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
