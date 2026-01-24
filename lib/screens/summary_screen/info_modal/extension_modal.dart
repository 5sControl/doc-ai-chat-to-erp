import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../helpers/email_validator.dart';
import '../../../services/summaryApi.dart';
import '../../modal_screens/purchase_success_screen.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class ExtensionModal extends StatefulWidget {
  const ExtensionModal({super.key});

  @override
  State<ExtensionModal> createState() => _ExtensionModalState();
}

class _ExtensionModalState extends State<ExtensionModal> {
  bool copied = false;
  bool isOpenLink = false;
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
    void onPressAdd() async {
      // Navigator.of(context).pop();
      // Future.delayed(Duration(milliseconds: 100), () {
      //   showMaterialModalBottomSheet(
      //       context: context,
      //       expand: false,
      //       bounce: false,
      //       barrierColor: Colors.black54,
      //       backgroundColor: Colors.transparent,
      //       enableDrag: false,
      //       builder: (context) {
      //         return const PurchaseSuccessScreen();
      //       });
      // });
    }

    void onPressCopy() async {
      setState(() {
        copied = true;
      });

      Clipboard.setData(const ClipboardData(
          text:
              'https://chromewebstore.google.com/detail/summify/necbpeagceabjjnliglmfeocgjcfimne'));

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          copied = false;
        });
      });

      context.read<MixpanelBloc>().add(const CopySummifyExtensionLink());
    }

    void onPressGift() async {
      if (!emailError && emailController.value.text.isNotEmpty) {
        await SummaryApiRepository()
            .sendEmail(email: emailController.value.text);
        if (context.mounted) {
          Navigator.of(context).pushNamed('/');
        }
      }
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Scaffold(
        body: Center(
          child: Container(
            width:MediaQuery.of(context).size.shortestSide <
                                            600 ?double.infinity : 343,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width:MediaQuery.of(context).size.shortestSide <
                                           600 ?double.infinity : 343,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                      alignment: Alignment.centerRight, child: BackArrow()),
                  AnimatedCrossFade(
                    secondChild: Center(
                      child: Container(
                          // width: 300,
                          // height: MediaQuery.of(context).size.height - 200,
                          // child: WebViewWidget(
                          //   controller: controller,
                          // ),
                          ),
                    ),
                    duration: Duration(milliseconds: 400),
                    crossFadeState: isOpenLink
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(AppLocalizations.of(context)!.extension_growYourProductivity,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SvgPicture.asset(
                          Assets.icons.oneOne,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).textTheme.bodySmall!.color!,
                              BlendMode.srcIn),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(fontWeight: FontWeight.w700),
                                children: [
                                  const TextSpan(text: "BUY "),
                                  WidgetSpan(
                                      child: SvgPicture.asset(
                                          Assets.icons.summafyMini),
                                      alignment: PlaceholderAlignment.middle),
                                  const TextSpan(text: " AND GET ON "),
                                  WidgetSpan(
                                      child: SvgPicture.asset(
                                        Assets.icons.desctop,
                                        colorFilter: ColorFilter.mode(
                                            Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .color!,
                                            BlendMode.srcIn),
                                      ),
                                      alignment: PlaceholderAlignment.middle),
                                  const TextSpan(text: " FOR FREE!"),
                                ])),
                        const SizedBox(
                          height: 10,
                        ),
                        // Padding(
                        //     padding: const EdgeInsets.symmetric(horizontal: 10),
                        //     child: Image.asset(Assets.extension.path)),
                        // Row(
                        //   children: [
                        //     MaterialButton(
                        //       color: Theme.of(context).primaryColor,
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(8)),
                        //       onPressed: onPressAdd,
                        //       child: const Text('Add Summify for your Chrome '),
                        //     ),
                        //     const Spacer(),
                        //     MaterialButton(
                        //       color: Theme.of(context).primaryColor,
                        //       shape: RoundedRectangleBorder(
                        //           borderRadius: BorderRadius.circular(8)),
                        //       onPressed: onPressCopy,
                        //       child: AnimatedCrossFade(
                        //         firstChild: SvgPicture.asset(
                        //           Assets.icons.copy,
                        //           colorFilter: const ColorFilter.mode(
                        //               Colors.white, BlendMode.srcIn),
                        //         ),
                        //         secondChild: Icon(Icons.check),
                        //         duration: const Duration(milliseconds: 300),
                        //         crossFadeState: copied
                        //             ? CrossFadeState.showSecond
                        //             : CrossFadeState.showFirst,
                        //       ),
                        //     )
                        //   ],
                        // ),
                        EmailField(emailController: emailController),
                        SizedBox(
                          height: 10,
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          Assets.icons.copy,
                                          colorFilter: const ColorFilter.mode(
                                              Colors.white, BlendMode.srcIn),
                                        ),
                                        Text(
                                          ' ${AppLocalizations.of(context)!.extension_copyLink}',
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
                                    overlayColor:
                                        const MaterialStatePropertyAll(
                                            Colors.white),
                                    onTap: onPressGift,
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Text(
                                          AppLocalizations.of(context)!.extension_sendLink,
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
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
      decoration: InputDecoration(
          hintText: ' ${AppLocalizations.of(context)!.extension_enterYourEmail}', fillColor: Colors.white),
      // onEditingComplete: () {},
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}

class BackArrow extends StatelessWidget {
  final bool? fromOnboarding;
  const BackArrow({super.key, this.fromOnboarding});

  @override
  Widget build(BuildContext context) {
    void onPressClose() {
      if (fromOnboarding != null) {
        Navigator.of(context).pushNamed('/');
        context.read<MixpanelBloc>().add(const ClosePaywall());
      } else {
        Navigator.of(context).pop();
      }
    }

    return IconButton(
        visualDensity: VisualDensity.compact,
        onPressed: onPressClose,
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
            minimumSize: MaterialStateProperty.all<Size>(Size(33, 33)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color:Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).iconTheme.color!.withOpacity(0))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.3),
        icon: Icon(
          Icons.close,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ));
  }
}