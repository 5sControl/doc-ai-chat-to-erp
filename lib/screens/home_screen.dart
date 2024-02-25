import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:summishare/screens/summary_screen.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressSharedItem(Summary summary) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SummaryScreen(
                  summaryData: summary,
                )),
      );
    }

    void onPressDelete(sharedLink) {
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: sharedLink));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SummiShare',
        ),
      ),
      body: BlocBuilder<SharedLinksBloc, SharedLinksState>(
          builder: (context, sharedLinksState) {
        return ListView.builder(
          itemCount: sharedLinksState.savedLinks.length,
          itemBuilder: (context, index) {
            final sharedLink = sharedLinksState.savedLinks.keys.toList()[index];
            final SummaryData? summaryData =
                sharedLinksState.savedLinks[sharedLink];
            final bool isLoading = summaryData?.status == SummaryStatus.Loading;
            final bool isError = summaryData?.status == SummaryStatus.Error;
            return InkWell(
              onTap: () {
                if (summaryData != null && summaryData.summary != null) {
                  onPressSharedItem(summaryData.summary!);
                }
              },
              child: ListTile(
                leading: AnimatedCrossFade(
                  duration: const Duration(milliseconds: 400),
                  firstChild: AnimatedCrossFade(
                    duration: const Duration(milliseconds: 400),
                    firstChild: const Icon(
                      Icons.check,
                      color: Colors.teal,
                      size: 30,
                    ),
                    secondChild: Icon(
                      Icons.error_outline,
                      color: Colors.red.shade400,
                    ),
                    crossFadeState: !isError
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                  secondChild: const CircularProgressIndicator(
                    color: Colors.teal,
                    strokeWidth: 2,
                    strokeCap: StrokeCap.round,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                  crossFadeState: !isLoading
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),
                title: Text(sharedLink),
                trailing: IconButton(
                  onPressed: () => onPressDelete(sharedLink),
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red.shade400,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
