import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/screens/subscribtions_screen/subscription_button.dart';
import 'package:summify/screens/subscribtions_screen/subscriptionsOnb_scree.dart';

import 'info_list.dart';

class SubscriptionBodyYear extends StatelessWidget {
  final Package package;
  const SubscriptionBodyYear({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    String currency({required String code}) {
      Locale locale = Localizations.localeOf(context);
      var format = NumberFormat.simpleCurrency(locale: locale.toString());
      return format.currencySymbol;
    }

    final currencySymbol = currency(code: package.storeProduct.currencyCode);

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(
            flex: 2,
          ),
          const Text(
            '12 months',
            textAlign: TextAlign.start,
            style:
                TextStyle(fontSize: 36, fontWeight: FontWeight.w400, height: 1),
          ),
          const Spacer(),
          const IconsRow(),
          const Spacer(),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text:
                    '$currencySymbol${(package.storeProduct.price + 25).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough)),
            TextSpan(
                text:
                    ' $currencySymbol${package.storeProduct.price.toStringAsFixed(2)}/year',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700)),
          ])),
          const Spacer(),
          Text(
            'Access all premium features!\nCancel anytime',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(
            flex: 2,
          ),
          SubscriptionButton(
            package: package,
          ),
          Divider(
            color: Theme.of(context).primaryColor,
            height: 45,
            thickness: 2,
            indent: 15,
            endIndent: 15,
          ),
          const InfoList()
        ],
      ),
    );
  }
}
