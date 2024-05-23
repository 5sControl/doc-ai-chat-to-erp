import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/subscriptions/subscriptions_bloc.dart';

class SummariesCounter extends StatelessWidget {
  final int dailySummaries;
  final int availableSummaries;

  const SummariesCounter({super.key,
    required this.dailySummaries,
    required this.availableSummaries});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
      builder: (context, state) {
        return Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Opacity(
              opacity: state.subscriptionStatus == SubscriptionStatus.subscribed ? 0 : 1,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  '$dailySummaries / $availableSummaries',
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
