import 'package:flutter/material.dart';

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(255, 238, 90, 1),
            Color.fromRGBO(255, 208, 74, 1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          overlayColor: const MaterialStatePropertyAll(Colors.white24),
          child: Center(
              child: Text(
                'Select',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
              )),
        ),
      ),
    );
  }
}