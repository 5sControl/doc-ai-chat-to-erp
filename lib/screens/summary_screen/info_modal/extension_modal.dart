import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class ExtensionModal extends StatefulWidget {
  const ExtensionModal({super.key});

  @override
  State<ExtensionModal> createState() => _ExtensionModalState();
}

class _ExtensionModalState extends State<ExtensionModal> {
  bool copied = false;
  bool isOpenLink = false;
  // late WebViewController controller;

  // void scrollToTop() async {
  //   await controller.loadRequest(Uri.parse('https://elang.app/summify'));
  //   // await controller.runJavaScript("window.scrollTo({top: 3325, behavior: 'smooth'});");
  // }

  // @override
  // void initState() {
  //   controller = WebViewController()
  //     // ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     // ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) async {
  //           // Update loading bar.
  //         },
  //         onPageStarted: (String url) {
  //           // scrollToTop();
  //         },
  //         onPageFinished: (String url) async {
  //           if (url.contains('elang.app/summify')) {
  //             await controller.runJavaScript(
  //                 "window.scrollTo({top: 3430, behavior: 'smooth'});");
  //           }
  //         },
  //         onHttpError: (HttpResponseError error) {},
  //         onWebResourceError: (WebResourceError error) {},
  //         onNavigationRequest: (NavigationRequest request) {
  //           // if (request.url.startsWith('https://www.youtube.com/')) {
  //           //   return NavigationDecision.prevent;
  //           // }
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     );
  //   controller.loadRequest(Uri.parse('https://elang.app/summify'));
  //   // scrollToTop();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    void onPressAdd() async {
      final Uri url = Uri.parse(
          'https://chromewebstore.google.com/detail/summify/necbpeagceabjjnliglmfeocgjcfimne');
      if (!await launchUrl(url, mode: LaunchMode.inAppBrowserView)) {}

      context.read<MixpanelBloc>().add(const RedirectToSummifyExtension());
      // setState(() {
      //   isOpenLink = !isOpenLink;
      // });
    }

    void onPressCopy() async {
      setState(() {
        copied = true;
      });

      Clipboard.setData(const ClipboardData(text: 'https://elang.app/summify'));

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          copied = false;
        });
      });

      context.read<MixpanelBloc>().add(const CopySummifyExtensionLink());
    }
    // final
    //   ..loadRequest(Uri.parse('https://elang.app/summify'));
    //

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Scaffold(
        body: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: double.infinity,
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
                          child: Text('GROW YOUR PRODUCTIVITY',
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
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Image.asset(Assets.extension.path)),
                        Row(
                          children: [
                            MaterialButton(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: onPressAdd,
                              child: const Text('Add Summify for your Chrome '),
                            ),
                            const Spacer(),
                            MaterialButton(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              onPressed: onPressCopy,
                              child: AnimatedCrossFade(
                                firstChild: SvgPicture.asset(
                                  Assets.icons.copy,
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                                secondChild: Icon(Icons.check),
                                duration: const Duration(milliseconds: 300),
                                crossFadeState: copied
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                              ),
                            )
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
                Theme.of(context).iconTheme.color!.withOpacity(0.2))),
        highlightColor: Theme.of(context).iconTheme.color!.withOpacity(0.2),
        icon: Icon(
          Icons.close,
          size: 20,
          color: Theme.of(context).iconTheme.color,
        ));
  }
}
