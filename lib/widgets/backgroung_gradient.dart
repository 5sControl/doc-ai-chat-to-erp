import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [ Colors.teal,  Colors.white],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft)),
    );
  }
}
