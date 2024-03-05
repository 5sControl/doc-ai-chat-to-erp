import 'package:flutter/material.dart';

class SummifyButton extends StatefulWidget {
  final String controllerText;
  final VoidCallback onPressSummify;
  const SummifyButton(
      {super.key, required this.onPressSummify, required this.controllerText});

  @override
  State<SummifyButton> createState() => _SummifyButtonState();
}

class _SummifyButtonState extends State<SummifyButton> {
  bool tapped = false;

  static const duration = Duration(milliseconds: 150);
  void onTapDown() {
    setState(() {
      tapped = true;
    });
  }

  void onTapUp() {
    Future.delayed(duration, () {
      setState(() {
        tapped = false;
      });
    });
  }

  void onTap() {
    Future.delayed(duration, () {
      widget.onPressSummify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapUp: (_) => onTapUp(),
      onTapDown: (_) => onTapDown(),
      onTapCancel: () => onTapUp(),
      child: AnimatedScale(
        duration: duration,
        scale: tapped ? 0.95 : 1,
        child: AnimatedContainer(
          duration: duration,
          padding: const EdgeInsets.symmetric(vertical: 10),
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: widget.controllerText.isNotEmpty
                  ? tapped
                      ? const Color.fromRGBO(49, 210, 206, 1)
                      : const Color.fromRGBO(4, 49, 57, 1)
                  : tapped
                      ? Colors.red.shade400
                      : const Color.fromRGBO(49, 210, 206, 1),
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
      ),
    );
  }
}
