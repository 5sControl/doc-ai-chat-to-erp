import 'package:cached_network_image/cached_network_image.dart';
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
            colorFilter: const ColorFilter.mode(
                Color.fromRGBO(6, 49, 57, 1), BlendMode.srcIn),
          ),
          const Text(
            '  Summify',
            style: TextStyle(color: Color.fromRGBO(6, 49, 57, 1)),
          )
        ],
      )),
      body: BlocBuilder<SharedLinksBloc, SharedLinksState>(
          builder: (context, sharedLinksState) {
        return ListView.builder(
          itemCount: sharedLinksState.savedLinks.length,
          itemBuilder: (context, index) {
            final sharedLink = sharedLinksState.savedLinks.keys.toList()[index];
            final SummaryData summaryData =
                sharedLinksState.savedLinks[sharedLink]!;
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
  final SummaryData summaryData;

  const ListTileElement(
      {super.key, required this.sharedLink, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    final displayLink = sharedLink.replaceAll('https://', '');
    final summaryDate = summaryData.date;
    final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
    final String formattedDate = formatter.format(summaryDate);

    void onPressSharedItem(SummaryData summaryData) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SummaryScreen(
                summaryData: summaryData,
                displayLink: summaryData.title ?? displayLink,
                formattedDate: formattedDate,
                sharedLink: sharedLink)),
      );
    }

    void onPressRetry() {
      context
          .read<SharedLinksBloc>()
          .add(SaveSharedLink(sharedLink: sharedLink));
    }

    void onPressDelete() {
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: sharedLink));
    }

    return AspectRatio(
      aspectRatio: 3.2,
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, blurStyle: BlurStyle.outer)
        ], color: Colors.white54, borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            if (summaryData.status == SummaryStatus.Complete) {
              onPressSharedItem(summaryData);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    // height: 80,

                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    child: Container(
                        child: switch (summaryData.status) {
                      SummaryStatus.Error =>
                        Image.asset('assets/placeholder_logo.png'),
                      SummaryStatus.Complete => Hero(
                          tag: summaryData.date,
                          child: summaryData.imageUrl == null
                              ? Image.asset('assets/placeholder_logo.png')
                              : CachedNetworkImage(
                                  imageUrl: summaryData.imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      SummaryStatus.Loading => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white70,
                            strokeCap: StrokeCap.round,
                          ),
                        )
                    }),
                  )),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        summaryData.title ?? displayLink,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        formattedDate,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: summaryData.status == SummaryStatus.Error
                    ? Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              tooltip: 'Retry',
                              onPressed: onPressRetry,
                              icon: const Icon(
                                Icons.change_circle_outlined,
                                color: Colors.black,
                              )),
                          IconButton(
                              onPressed: onPressDelete,
                              tooltip: 'Delete',
                              icon: SvgPicture.asset(
                                'assets/icons/delete.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.black, BlendMode.srcIn),
                              ))
                        ],
                      )
                    : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
