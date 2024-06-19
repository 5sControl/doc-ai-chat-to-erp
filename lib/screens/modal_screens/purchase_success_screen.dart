import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summify/screens/subscribtions_screen/happy_box.dart';

import '../../gen/assets.gen.dart';
import '../../helpers/email_validator.dart';

class PurchaseSuccessScreen extends StatefulWidget {
  const PurchaseSuccessScreen({super.key});

  @override
  State<PurchaseSuccessScreen> createState() => _PurchaseSuccessScreenState();
}

class _PurchaseSuccessScreenState extends State<PurchaseSuccessScreen> {
  bool emailError = false;
  final emailController = TextEditingController();

  @override
  void initState() {
    emailController.addListener(() {
      if (validateEmail(emailController.value.text) == null) {
        setState(() {
          emailError = false;
        });
      } else {
        setState(() {
          emailError = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onPressCopy() {
      print('copy');
    }

    void onPressGift() async {
      if (!emailError && emailController.value.text.isNotEmpty) {
        print('!!!!');
      }
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10)),
          child: SizedBox(
            width: double.infinity,
            child: Stack(
              fit: StackFit.loose,
              children: [
                const Positioned(top: 0, right: 0, child: BackArrow()),
                Positioned(
                    top: -35,
                    left: -30,
                    width: 120,
                    height: 200,
                    child: Transform.flip(
                        flipX: true,
                        child: Transform.scale(scale: 0.7, child: HappyBox()))),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      '   You are the best!',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    RichText(
                        text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontSize: 26),
                            children: [
                          const TextSpan(text: 'Get '),
                          WidgetSpan(
                              child: SvgPicture.asset(Assets.icons.chrome),
                              alignment: PlaceholderAlignment.middle),
                          const TextSpan(text: ' version for free!'),
                        ])),
                    const SizedBox(
                      height: 20,
                    ),
                    EmailField(
                      emailController: emailController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).primaryColor,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: onPressCopy,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.icons.copy,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.white, BlendMode.srcIn),
                                    ),
                                    Text(
                                      ' Copy link',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Container(
                            clipBehavior: Clip.hardEdge,
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
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.transparent,
                              child: InkWell(
                                overlayColor: const MaterialStatePropertyAll(
                                    Colors.white),
                                onTap: onPressGift,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      'Collect your gift',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                    )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  final TextEditingController emailController;
  const EmailField({super.key, required this.emailController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: emailController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validateEmail,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        hintText: ' Enter your email',
        fillColor: Colors.white
      ),
      // onEditingComplete: () {},
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}

class BackArrow extends StatelessWidget {
  const BackArrow({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      Navigator.of(context).pop();
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: const MaterialStatePropertyAll(EdgeInsets.all(0)),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0.1))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.2),
        icon: const Icon(
          Icons.close,
          size: 20,
          color: Colors.white,
        ));
  }
}
