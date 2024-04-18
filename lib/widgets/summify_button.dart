import 'package:flutter/material.dart';

class SummifyButton extends StatelessWidget {
  final String controllerText;
  final VoidCallback onPressSummify;
  const SummifyButton(
      {super.key, required this.onPressSummify, required this.controllerText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Material(
        color: Theme.of(context).primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: InkWell(
          highlightColor: controllerText.isNotEmpty
              ? Colors.white24
              : Colors.red.withOpacity(0.6),
          borderRadius: BorderRadius.circular(8),
          onTap: onPressSummify,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
