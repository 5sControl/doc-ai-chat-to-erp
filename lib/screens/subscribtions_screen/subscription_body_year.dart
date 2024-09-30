import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:summify/screens/subscribtions_screen/subscription_button.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen.dart';

import '../../bloc/settings/settings_bloc.dart';
import 'info_list.dart';

class SubscriptionBodyYear extends StatelessWidget {
  final Package package;
  const SubscriptionBodyYear({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    String currency({required String code}) {
      Locale locale = Localizations.localeOf(context);
      var format = NumberFormat.simpleCurrency(locale: locale.toString());
      return format.simpleCurrencySymbol(code);
    }

    final currencySymbol = currency(code: package.storeProduct.currencyCode.toUpperCase());
    final abTest = context.read<SettingsBloc>().state.abTest;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(
            flex: 2,
          ),
         Text(
            '12 months',
            textAlign: TextAlign.start,
            style:
                TextStyle(fontSize:MediaQuery.of(context).size.shortestSide <
                                            600 ? 36 : 56, fontWeight: FontWeight.w400, height: 1),
          ),
          const Spacer(),
          if (abTest == 'A')
            const IconsRow(),
          if (abTest == 'A')
            const Spacer(),
          RichText(
              text: TextSpan(children: [
            TextSpan(
                text:
                    '$currencySymbol${(package.storeProduct.price + 25).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: MediaQuery.of(context).size.shortestSide <
                                            600 ? 24 : 44,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough)),
            TextSpan(
                text:
                    ' $currencySymbol${package.storeProduct.price.toStringAsFixed(2)}/year',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.shortestSide <
                                            600 ? 24 : 44,)),
          ])),
          const Spacer(),
          Text(
            'Access all premium features!\nCancel anytime',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: MediaQuery.of(context).size.shortestSide <
                                            600 ? 14 : 24,),
          ),
          const Spacer(
            flex: 2,
          ),
          SubscriptionButton(
            package: package,
          ),
          Divider(
            // color: Theme.of(context).primaryColor,
            color: Colors.transparent,
            height: 15,
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
