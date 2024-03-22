import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/shared_links/shared_links_bloc.dart';
import 'package:summify/widgets/modal_handle.dart';

import '../../gen/assets.gen.dart';
import '../../widgets/summify_button.dart';
import '../subscription_screen.dart';

class TextModalScreen extends StatefulWidget {
  const TextModalScreen({super.key});

  @override
  State<TextModalScreen> createState() => _TextModalScreenState();
}

class _TextModalScreenState extends State<TextModalScreen> {
  final TextEditingController textController = TextEditingController();
  var controllerText = '';
  // void onPressSummify() {
  //
  // }

  void onPressSummify() {
    final DateFormat formatter = DateFormat('MM.dd.yy');
    final thisDay = formatter.format(DateTime.now());
    final limit = context.read<SharedLinksBloc>().state.dailyLimit;
    final daySummaries =
        context.read<SharedLinksBloc>().state.dailySummariesMap[thisDay] ?? 15;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (daySummaries >= limit) {
        showCupertinoModalBottomSheet(
          context: context,
          expand: false,
          bounce: false,
          barrierColor: Colors.black54,
          backgroundColor: Colors.transparent,
          // enableDrag: false,
          builder: (context) {
            return const SubscriptionScreen();
          },
        );
      } else if (textController.text.isNotEmpty) {
        context
            .read<SharedLinksBloc>()
            .add(SaveText(text: textController.text));

        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
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
      color: const Color.fromRGBO(227, 255, 254, 1),
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
            const Text(
              'Enter Text',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
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
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white70,
                        border: Border.all(
                            color: Colors.teal.withOpacity(0.5), width: 1),
                        borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      maxLines: null,
                      expands: true,
                      autofocus: false,
                      controller: controller,
                      keyboardType: TextInputType.multiline,
                      textAlignVertical: TextAlignVertical.top,
                      cursorWidth: 3,
                      cursorColor: Colors.black54,
                      cursorHeight: 20,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2,
                              color:
                                  Color.fromRGBO(4, 49, 57, 1)), //<-- SEE HERE
                        ),
                        label: Container(
                          padding: const EdgeInsets.symmetric(vertical: 7),
                          height: double.infinity,
                          child: const Text(
                            'Start typing or paste your text here ...',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        border: OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: GestureDetector(
                      onTap: onPressPaste,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 2, vertical: 2),
                        margin: const EdgeInsets.only(left: 17, bottom: 17),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromRGBO(227, 255, 254, 1)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: const EdgeInsets.only(left: 7),
                                child: SvgPicture.asset(
                                  Assets.icons.paste,
                                )),
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text(
                                  'Paste',
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w300),
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
