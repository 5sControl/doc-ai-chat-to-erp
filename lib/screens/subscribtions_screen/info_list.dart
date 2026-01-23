import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../gen/assets.gen.dart';
import '../summary_screen/info_modal/extension_modal.dart';

class InfoList extends StatelessWidget {
  const InfoList({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final List<String> infoItems = [
      l10n.paywall_unlimitedSummaries,
      l10n.paywall_documentResearch,
      l10n.paywall_briefAndDeepSummary,
      l10n.paywall_translation,
    ];

    void onPressExtensionLink() {
      showMaterialModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          enableDrag: false,
          builder: (context) {
            return const ExtensionModal();
          });
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 20),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        ...infoItems
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: SvgPicture.asset(
                          Assets.icons.check,
                          colorFilter: const ColorFilter.mode(
                              Colors.white, BlendMode.srcIn),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        e,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.w400, fontSize: MediaQuery.of(context).size.shortestSide <
                                            600 ? 18 : 24,),
                      ),
                    ],
                  ),
                ))
            .toList(),
        //if (abTest != 'A')
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20)),
                child: SvgPicture.asset(
                  Assets.icons.check,
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: onPressExtensionLink,
                child: Text(
                  l10n.paywall_addToChromeForFree,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.shortestSide <
                                            600 ? 18 : 24,
                      decoration: TextDecoration.underline),
                ),
              ),
            ],
          )
      ],
    );
  }
}
