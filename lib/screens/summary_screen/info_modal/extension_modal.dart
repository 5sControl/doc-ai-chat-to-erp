import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

const _extensionChromeStoreUrl =
    'https://chromewebstore.google.com/detail/summify/necbpeagceabjjnliglmfeocgjcfimne';

class ExtensionModal extends StatefulWidget {
  const ExtensionModal({super.key});

  @override
  State<ExtensionModal> createState() => _ExtensionModalState();
}

class _ExtensionModalState extends State<ExtensionModal> {
  bool copied = false;

  @override
  Widget build(BuildContext context) {
    void onPressCopy() async {
      setState(() {
        copied = true;
      });

      Clipboard.setData(
          const ClipboardData(text: _extensionChromeStoreUrl));

      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) setState(() => copied = false);
      });

      context.read<MixpanelBloc>().add(const CopySummifyExtensionLink());
    }

    Future<void> onPressOpenLink() async {
      final uri = Uri.parse(_extensionChromeStoreUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        if (context.mounted) {
          context.read<MixpanelBloc>().add(const RedirectToSummifyExtension());
        }
      }
    }

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
      child: Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.shortestSide < 600
                ? double.infinity
                : 343,
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              width: MediaQuery.of(context).size.shortestSide < 600
                  ? double.infinity
                  : 343,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                      alignment: Alignment.centerRight, child: BackArrow()),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                            AppLocalizations.of(context)!
                                .extension_growYourProductivity,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      const SizedBox(height: 10),
                      SvgPicture.asset(
                        Assets.icons.oneOne,
                        colorFilter: ColorFilter.mode(
                            Theme.of(context).textTheme.bodySmall!.color!,
                            BlendMode.srcIn),
                      ),
                      const SizedBox(height: 10),
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
                                      Assets.icons.phone,
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color!,
                                          BlendMode.srcIn),
                                    ),
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
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          AppLocalizations.of(context)!
                              .extension_buyMobileGetDesktop,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                      ),
                      const SizedBox(height: 10),
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
                                      vertical: 10, horizontal: 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SvgPicture.asset(
                                        Assets.icons.copy,
                                        colorFilter: const ColorFilter.mode(
                                            Colors.white, BlendMode.srcIn),
                                      ),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .extension_copyLink,
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
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
                                  onTap: onPressOpenLink,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.open_in_new,
                                            size: 20, color: Colors.black),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .extension_openLink,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
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
                side: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black),
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
