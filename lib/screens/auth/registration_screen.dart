// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/helpers/show_error_toast.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/screens/settings_screen/settings_screen.dart';
import 'package:summify/screens/subscribtions_screen/happy_box.dart';
import 'package:summify/widgets/backgroung_gradient.dart';
import 'package:summify/widgets/summify_button.dart';

import '../../bloc/authentication/authentication_bloc.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';

  @override
  void initState() {
    nameController.addListener(() {
      setState(() {
        name = nameController.text;
      });
    });
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
    confirmPasswordController.addListener(() {
      setState(() {
        confirmPassword = confirmPasswordController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onPressRegister() {
      if (password != confirmPassword) {
        showErrorToast(context: context, error: AppLocalizations.of(context)!.registration_passwordMismatch);
      } else {
        context
            .read<AuthenticationBloc>()
            .add(SignUpWithEmail(name: name, email: email, password: password));
      }
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

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        // listenWhen: (previous, current) {
        //   return previous is AuthenticationLoadingState && current is AuthenticationFailureState;
        // },
        listener: (context, state) {
      if (state is AuthenticationSuccessState) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
      if (state is AuthenticationFailureState) {
        print('asdasd');
        () => showErrorToast(context: context, error: state.errorMessage);
      }
    }, builder: (context, state) {
      return Stack(children: [
        const BackgroundGradient(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: 24,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/bundle');
                  },
                  child: Text(
                    AppLocalizations.of(context)!.registration_skip,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black),
                  ))
            ],
          ),
          body: Stack(children: [
            Positioned(
                right: 0,
                top: MediaQuery.of(context).size.shortestSide < 600 ? 30 : 50,
                child: SizedBox(
                  height: MediaQuery.of(context).size.shortestSide < 600
                      ? 150
                      : 220,
                  width: MediaQuery.of(context).size.shortestSide < 600
                      ? 150
                      : 220,
                  child: HappyBox(),
                )),
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 18),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 26,
                        ),
                        Text(
                          AppLocalizations.of(context)!.registration_registerAndGet,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide < 600
                                      ? 30
                                      : 56,
                              height: 1.2,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(children: [
                          Text(
                            AppLocalizations.of(context)!.registration_1FreePerDay,
                            //maxLines: 2,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.shortestSide <
                                            600
                                        ? 30
                                        : 56,
                                //height: 1.2,
                                fontWeight: FontWeight.w700),
                          ),
                          Container(
                            //width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: const LinearGradient(
                                    colors: [
                                      Color.fromRGBO(255, 238, 90, 1),
                                      Color.fromRGBO(255, 208, 74, 1),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter)),
                            child: Material(
                              color: Colors.transparent,
                              child: Center(
                                  child: Text(
                                AppLocalizations.of(context)!.registration_unlimited,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: MediaQuery.of(context)
                                                  .size
                                                  .shortestSide <
                                              600
                                          ? 30
                                          : 56,
                                    ),
                              )),
                            ),
                          ),
                        ]),
                        Text(
                          AppLocalizations.of(context)!.registration_summarizations,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.shortestSide < 600
                                      ? 30
                                      : 56,
                              height: 1.2,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NameInput(controller: nameController),
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
                        const Divider(
                          color: Colors.transparent,
                          height: 20,
                        ),
                        ConfirmPasswordInput(
                            controller: confirmPasswordController),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SignUpButton(
                      onPress: onPressRegister,
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    const DividerRow(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: onPressGoogle,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 10, right: 30, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(234, 245, 246, 0.298),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child:
                                    SvgPicture.asset('assets/icons/google.svg'),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: onPressApple,
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 10, right: 30, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(234, 245, 246, 0.298),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: SvgPicture.asset(
                                  'assets/icons/apple.svg',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                            text: AppLocalizations.of(context)!.registration_alreadyHaveAccount,
                            style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15),
                            children: <TextSpan>[
                              TextSpan(
                                  text: AppLocalizations.of(context)!.registration_loginNow,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pop();
                                    })
                            ]),
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
          ]),
        ),
      ]);
    });
  }
}

class NameInput extends StatelessWidget {
  final TextEditingController controller;
  const NameInput({super.key, required this.controller});

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
            AppLocalizations.of(context)!.registration_name,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
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
            AppLocalizations.of(context)!.registration_emailAddress,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
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
            AppLocalizations.of(context)!.registration_password,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
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
            AppLocalizations.of(context)!.registration_confirmPassword,
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.w400),
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
        height: 50,
        //padding: const EdgeInsets.symmetric(vertical: 18),
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(0, 186, 195, 1),
            borderRadius: BorderRadius.circular(8)),
        child: Text(
          AppLocalizations.of(context)!.registration_register,
          style: const TextStyle(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              AppLocalizations.of(context)!.registration_orLoginWith,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
