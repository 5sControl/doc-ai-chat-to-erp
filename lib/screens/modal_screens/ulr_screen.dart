import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/widgets/modal_handle.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/summaries/summaries_bloc.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/summify_button.dart';
import '../subscription_screen.dart';

class UrlModalScreen extends StatefulWidget {
  const UrlModalScreen({super.key});

  @override
  State<UrlModalScreen> createState() => _UrlModalScreenState();
}

class _UrlModalScreenState extends State<UrlModalScreen> {
  final TextEditingController urlController = TextEditingController();
  var controllerText = '';

  void onChangeText() {
    setState(() {
      controllerText = urlController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    urlController.addListener(onChangeText);
  }

  @override
  void dispose() {
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void onPressSummify() {
      final DateFormat formatter = DateFormat('MM.dd.yy');
      final thisDay = formatter.format(DateTime.now());
      final limit = context.read<SummariesBloc>().state.dailyLimit;
      final daySummaries =
          context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 0;

      Future.delayed(const Duration(milliseconds: 300), () {
        if (daySummaries >= limit) {
          showCupertinoModalBottomSheet(
            context: context,
            expand: false,
            bounce: false,
            barrierColor: Colors.black54,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const SubscriptionScreen();
            },
          );
          context.read<MixpanelBloc>().add(
              LimitReached(resource: urlController.text, registrated: false));
        } else if (controllerText.isNotEmpty) {
          context.read<SummariesBloc>().add(GetSummaryFromUrl(
              summaryUrl: urlController.text, fromShare: false));
          Navigator.of(context).pop();
        }
      });
    }

    void onPressPaste() async {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        urlController.text = clipboardData!.text.toString();
      }
    }

    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const ModalHandle(),
            Text(
              'Enter URL',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            UrlTextField(controller: urlController, onPressPaste: onPressPaste),
            SummifyButton(
              onPressSummify: onPressSummify,
              controllerText: controllerText,
            )
          ],
        ),
      ),
    );
  }
}

class UrlTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onPressPaste;
  const UrlTextField(
      {super.key, required this.controller, required this.onPressPaste});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                height: 40,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(1, 1))
                ]),
                child: TextFormField(
                  controller: controller,
                  onChanged: (text) {
                    controller.text = text;
                  },
                  cursorColor: Colors.black54,
                  cursorHeight: 20,
                  style: Theme.of(context).textTheme.labelMedium,
                  decoration: const InputDecoration(
                    hintText: 'Paste link',
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onPressPaste,
              child: Container(
                  margin: const EdgeInsets.only(left: 7),
                  child: SvgPicture.asset(
                    Assets.icons.paste,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColorLight, BlendMode.srcIn),
                  )),
            )
          ],
        ));
  }
}
