import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.teal.shade900, Colors.teal, Colors.teal,  Colors.teal.shade900],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
    );
  }
}
