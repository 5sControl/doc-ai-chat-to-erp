import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';

class SubscriptionButton extends StatelessWidget {
  final Package package;
  const SubscriptionButton({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    void onPressSubscribe() {
      context
          .read<SubscriptionsBloc>()
          .add(MakePurchase(context: context, product: package));
    }

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
          onTap: onPressSubscribe,
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
