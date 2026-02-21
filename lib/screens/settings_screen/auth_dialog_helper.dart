import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/subscriptions/subscriptions_bloc.dart';

void showAuthDialog(
  BuildContext context, {
  required String title,
  required String subTitle,
  required String confirmButtonText,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? const Color.fromRGBO(5, 49, 57, 1)
                    : const Color.fromRGBO(227, 255, 254, 1),
          ),
          width:
              MediaQuery.of(context).size.shortestSide > 600
                  ? 343
                  : MediaQuery.of(context).size.width - 20,
          height:
              MediaQuery.of(context).size.shortestSide > 600 ? 250 : 230,
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 23,
                ),
              ),
              const SizedBox(height: 7),
              Expanded(
                child: Center(
                  child: Text(
                    subTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? const Color.fromRGBO(132, 134, 152, 1)
                              : null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (confirmButtonText == 'Yes, log out') {
                        context.read<AuthenticationBloc>().add(SignOut());
                        context.read<SubscriptionsBloc>().add(
                              GetSubscriptionStatus(),
                            );
                        Navigator.of(context).pop();
                      } else if (confirmButtonText == 'Yes, delete') {
                        context.read<AuthenticationBloc>().add(
                              DeleteUser(),
                            );
                        Navigator.of(context).pop();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width:
                          MediaQuery.of(context).size.shortestSide > 600
                              ? 343 / 2.3
                              : MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                      child: Text(
                        confirmButtonText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      width:
                          MediaQuery.of(context).size.shortestSide > 600
                              ? 343 / 2.3
                              : MediaQuery.of(context).size.width / 2.3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      );
    },
  );
}
