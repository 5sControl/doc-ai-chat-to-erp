import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/shared_links/shared_links_bloc.dart';
import 'package:summify/widgets/modal_handle.dart';

class TextModalScreen extends StatefulWidget {
  const TextModalScreen({super.key});

  @override
  State<TextModalScreen> createState() => _TextModalScreenState();
}

class _TextModalScreenState extends State<TextModalScreen> {
  final TextEditingController textController = TextEditingController();

  void onPressSummify() {
    if (textController.text.isNotEmpty) {
      context.read<SharedLinksBloc>().add(SaveText(text: textController.text));

      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }

  void onPressPaste() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      textController.text = clipboardData!.text.toString();
    }
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
            MyTextField(controller: textController),
            SummifyButton(onPress: onPressSummify)
          ],
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  const MyTextField({super.key, required this.controller});

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
              // margin: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(8)),
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    border: Border.all(
                        color: Colors.teal.withOpacity(0.5), width: 1),
                    borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  maxLines: null,
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
                    label: const Text(
                      'Start typing or paste your content here ...',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    border: OutlineInputBorder(
                        gapPadding: 10,
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none),
                    // floatingLabelStyle: const TextStyle(
                    //     color: Colors.white,
                    //     // height: -2,
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w500)
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

class SummifyButton extends StatelessWidget {
  final VoidCallback onPress;
  const SummifyButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.teal.shade300,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26, blurRadius: 5, offset: Offset(1, 1))
            ]),
        child: const Text(
          'Summify Now',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
