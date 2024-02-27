import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:summify/screens/summary_screen.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/logo.svg',
            height: 30,
            width: 30,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const Text(
            '  Summify',
            style: TextStyle(color: Colors.white),
          )
        ],
      )),
      body: BlocBuilder<SharedLinksBloc, SharedLinksState>(
          builder: (context, sharedLinksState) {
        return ListView.builder(
          itemCount: sharedLinksState.savedLinks.length,
          itemBuilder: (context, index) {
            final sharedLink = sharedLinksState.savedLinks.keys.toList()[index];
            final SummaryData? summaryData =
                sharedLinksState.savedLinks[sharedLink];
            return ListTileElement(
              sharedLink: sharedLink,
              summaryData: summaryData,
            );
          },
        );
      }),
    );
  }
}

class ListTileElement extends StatelessWidget {
  final String sharedLink;
  final SummaryData? summaryData;

  const ListTileElement(
      {super.key, required this.sharedLink, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    final bool isLoading = summaryData?.status == SummaryStatus.Loading;
    final bool isError = summaryData?.status == SummaryStatus.Error;
    final displayLink = sharedLink.replaceAll('https://', '');
    final summaryDate = summaryData!.date;
    final DateFormat formatter = DateFormat('H:m E, MM.dd.yy');
    final String formattedDate = formatter.format(summaryDate);

    void onPressSharedItem(Summary summary) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SummaryScreen(
                summary: summary,
                displayLink: displayLink,
                formattedDate: formattedDate,
                sharedLink: sharedLink)),
      );
      // Navigator.pushNamed(context, '/summary', arguments: summary);
    }

    void onPressDelete(sharedLink) {
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: sharedLink));
    }

    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white54, borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        onTap: () {
          if (summaryData != null && summaryData!.summary != null) {
            onPressSharedItem(summaryData!.summary!);
          }
        },
        leading: AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          firstChild: AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            firstChild: const Icon(
              Icons.check,
              color: Colors.white,
              size: 30,
            ),
            secondChild: Icon(
              Icons.error_outline,
              color: Colors.red.shade400,
            ),
            crossFadeState:
                !isError ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          ),
          secondChild: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
            strokeCap: StrokeCap.round,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
          crossFadeState:
              !isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
        title: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              displayLink,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18),
            ),
            Divider(color: Colors.transparent),
            Text(
              formattedDate,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
