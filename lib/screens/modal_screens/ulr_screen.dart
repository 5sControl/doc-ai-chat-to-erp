import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/widgets/modal_handle.dart';

class UrlModalScreen extends StatefulWidget {
  const UrlModalScreen({super.key});

  @override
  State<UrlModalScreen> createState() => _UrlModalScreenState();
}

class _UrlModalScreenState extends State<UrlModalScreen> {
  final TextEditingController urlController = TextEditingController();

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
              'Enter URL',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            UrlTextField(controller: urlController),
            const SummifyButton()
          ],
        ),
      ),
    );
  }
}

class UrlTextField extends StatelessWidget {
  final TextEditingController controller;
  const UrlTextField({super.key, required this.controller});

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
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(1, 1))
                ]),
                child: TextField(
                  textAlignVertical: TextAlignVertical.top,
                  controller: controller,
                  cursorWidth: 3,
                  cursorColor: Colors.black54,
                  cursorHeight: 20,
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  decoration: InputDecoration(
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1, color: Colors.teal), //<-- SEE HERE
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 0),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      label: const Padding(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Text(
                          'Paste link',
                          style: TextStyle(),
                        ),
                      ),
                      border: OutlineInputBorder(
                          gapPadding: 10,
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 7),
                child: SvgPicture.asset('assets/icons/copy.svg'))
          ],
        ));
  }
}

class SummifyButton extends StatelessWidget {
  const SummifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
