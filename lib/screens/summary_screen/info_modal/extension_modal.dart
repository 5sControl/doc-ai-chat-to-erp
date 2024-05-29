import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:url_launcher/url_launcher.dart';

class ExtensionModal extends StatefulWidget {
  const ExtensionModal({super.key});

  @override
  State<ExtensionModal> createState() => _ExtensionModalState();
}

class _ExtensionModalState extends State<ExtensionModal> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    void onPressAdd() async {
      final Uri url = Uri.parse(
          'https://chromewebstore.google.com/detail/summify/necbpeagceabjjnliglmfeocgjcfimne?pli=1');
      if (!await launchUrl(url)) {}

      context.read<MixpanelBloc>().add(const RedirectToSummifyExtension());
    }

    void onPressCopy() async {
      setState(() {
        copied = true;
      });

      Clipboard.setData(const ClipboardData(
          text:
              'https://chromewebstore.google.com/detail/summify/necbpeagceabjjnliglmfeocgjcfimne?pli=1'));

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() {
          copied = false;
        });
      });

      context.read<MixpanelBloc>().add(const CopySummifyExtensionLink());
    }

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
                                child:
                                    SvgPicture.asset(Assets.icons.summafyMini),
                                alignment: PlaceholderAlignment.middle),
                            const TextSpan(text: " AND GET ON "),
                            WidgetSpan(
                                child: SvgPicture.asset(Assets.icons.desctop),
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
