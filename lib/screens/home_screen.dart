import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:summify/screens/summary_screen.dart';

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
          title: Row(
        children: [
          SvgPicture.asset(
            'assets/svg/logo.svg',
            height: 40,
            width: 40,
            colorFilter:
                ColorFilter.mode(Colors.teal.shade500, BlendMode.srcIn),
          ),
          const Text(
            '  Summify',
            style: TextStyle(color: Colors.black),
          )
        ],
      )
          // centerTitle: false,
          ),
      body: BlocBuilder<SharedLinksBloc, SharedLinksState>(
          builder: (context, sharedLinksState) {
        return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
            itemCount: sharedLinksState.savedLinks.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // number of items in each row
                mainAxisSpacing: 35.0, // spacing between rows
                crossAxisSpacing: 35.0,
                childAspectRatio: 0.9 // spacing between columns
                ),
            itemBuilder: (context, index) {
              final sharedLink =
                  sharedLinksState.savedLinks.keys.toList()[index];
              final SummaryData? summaryData =
                  sharedLinksState.savedLinks[sharedLink];
              return Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.teal.withOpacity(0.1),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 0),
                          blurRadius: 6,
                          spreadRadius: 1,
                          blurStyle: BlurStyle.outer)
                    ]), // color of grid items
                child: InkWell(
                  onTap: () {
                    if (summaryData != null && summaryData.summary != null) {
                      onPressSharedItem(summaryData.summary!);
                    }
                  },
                  child: Container(
                    child: Text(
                      // sharedLink,
                      'Summary',
                      style: TextStyle(
                          fontSize: 18.0, color: Colors.black, inherit: true),
                    ),
                  ),
                ),
              );
            });
        // return ListView.builder(
        //   itemCount: sharedLinksState.savedLinks.length,
        //   itemBuilder: (context, index) {
        //     final sharedLink = sharedLinksState.savedLinks.keys.toList()[index];
        //     final SummaryData? summaryData =
        //         sharedLinksState.savedLinks[sharedLink];
        //     final bool isLoading = summaryData?.status == SummaryStatus.Loading;
        //     final bool isError = summaryData?.status == SummaryStatus.Error;
        //     return InkWell(
        //       onTap: () {
        //         if (summaryData != null && summaryData.summary != null) {
        //           onPressSharedItem(summaryData.summary!);
        //         }
        //       },
        //       child: ListTile(
        //         leading: AnimatedCrossFade(
        //           duration: const Duration(milliseconds: 400),
        //           firstChild: AnimatedCrossFade(
        //             duration: const Duration(milliseconds: 400),
        //             firstChild: const Icon(
        //               Icons.check,
        //               color: Colors.teal,
        //               size: 30,
        //             ),
        //             secondChild: Icon(
        //               Icons.error_outline,
        //               color: Colors.red.shade400,
        //             ),
        //             crossFadeState: !isError
        //                 ? CrossFadeState.showFirst
        //                 : CrossFadeState.showSecond,
        //           ),
        //           secondChild: const CircularProgressIndicator(
        //             color: Colors.teal,
        //             strokeWidth: 2,
        //             strokeCap: StrokeCap.round,
        //             strokeAlign: BorderSide.strokeAlignInside,
        //           ),
        //           crossFadeState: !isLoading
        //               ? CrossFadeState.showFirst
        //               : CrossFadeState.showSecond,
        //         ),
        //         title: Text(sharedLink),
        //         trailing: IconButton(
        //           onPressed: () => onPressDelete(sharedLink),
        //           icon: Icon(
        //             Icons.delete_forever,
        //             color: Colors.red.shade400,
        //           ),
        //         ),
        //       ),
        //     );
        //   },
        // );
      }),
    );
  }
}
