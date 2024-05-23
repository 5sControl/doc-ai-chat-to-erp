import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/widgets/modal_handle.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../bloc/summaries/summaries_bloc.dart';
import '../../gen/assets.gen.dart';
import '../../widgets/summify_button.dart';
import '../subscribtions_screen/subscriptions_screen.dart';

class TextModalScreen extends StatefulWidget {
  const TextModalScreen({super.key});

  @override
  State<TextModalScreen> createState() => _TextModalScreenState();
}

class _TextModalScreenState extends State<TextModalScreen> {
  final TextEditingController textController = TextEditingController();
  var controllerText = '';

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
            LimitReached(resource: textController.text, registrated: false));
      } else if (controllerText.isNotEmpty) {
        context
            .read<SummariesBloc>()
            .add(GetSummaryFromText(text: textController.text));
        Navigator.of(context).pop();
      }
    });
  }

  void onPressPaste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      textController.text = clipboardData!.text.toString();
    }
  }

  void onChangeText() {
    setState(() {
      controllerText = textController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(onChangeText);
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              'Enter Text',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            MyTextField(controller: textController, onPressPaste: onPressPaste),
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

class MyTextField extends StatelessWidget {
  final VoidCallback onPressPaste;
  final TextEditingController controller;
  const MyTextField(
      {super.key, required this.controller, required this.onPressPaste});

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white54, borderRadius: BorderRadius.circular(8)),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 50,
              maxHeight: deviceWidth - 100,
            ),
            child: Container(
              height: deviceWidth,
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8)),
              child: Stack(
                fit: StackFit.expand,
                // alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    // margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextFormField(
                      maxLines: null,
                      expands: true,
                      autofocus: false,
                      controller: controller,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      cursorWidth: 3,
                      cursorColor: Theme.of(context).cardColor,
                      cursorHeight: 20,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                          fillColor:
                              Theme.of(context).canvasColor.withAlpha(240),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                width: 1,
                              )),
                          hintText: 'Start typing or paste your text here ...',
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w400)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: onPressPaste,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 3),
                        margin: const EdgeInsets.only(left: 17, bottom: 17),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).primaryColor),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 7),
                                child: SvgPicture.asset(
                                  Assets.icons.paste,
                                  colorFilter: ColorFilter.mode(
                                      Theme.of(context).primaryColorLight,
                                      BlendMode.srcIn),
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'Paste',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .copyWith(
                                    color: Theme.of(context).primaryColorLight,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
