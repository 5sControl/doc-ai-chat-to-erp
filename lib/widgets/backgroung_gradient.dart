import 'package:flutter/material.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/BG.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover)),
    );
    // return Container(
    //   decoration: BoxDecoration(
    //       gradient: LinearGradient(
    //           colors: [Colors.pink.shade400, Colors.pink.shade500, Colors.white],
    //           begin: Alignment.topCenter,
    //           end: Alignment.bottomCenter)),
    // );
  }
}
