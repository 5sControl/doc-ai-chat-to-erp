import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../screens/summary_screen.dart';

class SummaryTile extends StatefulWidget {
  final String sharedLink;
  final SummaryData summaryData;

  const SummaryTile(
      {super.key, required this.sharedLink, required this.summaryData});

  @override
  State<SummaryTile> createState() => _SummaryTileState();
}

class _SummaryTileState extends State<SummaryTile> {
  bool tapped = false;

  static const duration = Duration(milliseconds: 200);
  void onTapDown() {
    setState(() {
      tapped = true;
    });
  }

  void onTapUp() {
    Future.delayed(duration, () {
      setState(() {
        tapped = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayLink = widget.sharedLink.replaceAll('https://', '');
    final summaryDate = widget.summaryData.date;
    final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
    final String formattedDate = formatter.format(summaryDate);

    void onPressSharedItem(SummaryData summaryData) {
      Future.delayed(duration, () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SummaryScreen(
                  summaryData: summaryData,
                  displayLink: summaryData.title ?? displayLink,
                  formattedDate: formattedDate,
                  sharedLink: widget.sharedLink)),
        );
      });
    }

    void onPressRetry() {
      context
          .read<SharedLinksBloc>()
          .add(SaveSharedLink(sharedLink: widget.sharedLink));
    }

    void onPressDelete() {
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: widget.sharedLink));
    }

    void onPressCancel() {
      context.read<SharedLinksBloc>().add(const CancelRequest());
    }

    return Dismissible(
      behavior: HitTestBehavior.translucent,
      key: Key(widget.sharedLink),
      onDismissed: (direction) {
        print('remove');
      },
      background: Container(
        color: Colors.red,
      ),
      child: ListTile(
        leading: null,
        trailing: null,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.zero,
        title: AnimatedScale(
          scale: tapped ? 0.98 : 1,
          duration: duration,
          child: AspectRatio(
            aspectRatio: 3.2,
            child: AnimatedContainer(
              duration: duration,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: tapped ? Colors.black54 : Colors.black26,
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer)
                  ],
                  color: tapped
                      ? const Color.fromRGBO(213, 255, 252, 1.0)
                      : const Color.fromRGBO(238, 255, 254, 1),
                  borderRadius: BorderRadius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  if (widget.summaryData.status == SummaryStatus.Complete) {
                    onPressSharedItem(widget.summaryData);
                  }
                },
                onTapUp: (_) {
                  onTapUp();
                },
                onTapCancel: () {
                  onTapUp();
                },
                onTapDown: (_) {
                  onTapDown();
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
                              child: switch (widget.summaryData.status) {
                            SummaryStatus.Error =>
                              Image.asset(Assets.placeholderLogo.path),
                            SummaryStatus.Complete => Hero(
                                tag: widget.summaryData.date,
                                child: widget.summaryData.imageUrl == null
                                    ? Image.asset(Assets.placeholderLogo.path)
                                    : CachedNetworkImage(
                                        imageUrl: widget.summaryData.imageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            SummaryStatus.Loading => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.teal,
                                  strokeCap: StrokeCap.round,
                                ),
                              )
                          }),
                        )),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.summaryData.title ?? displayLink,
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
                      child: widget.summaryData.status == SummaryStatus.Error
                          ? Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                    tooltip: 'Retry',
                                    onPressed: onPressRetry,
                                    highlightColor: Colors.teal,
                                    // style:  ButtonStyle(
                                    //     backgroundColor:
                                    //         MaterialStatePropertyAll(Colors.teal.withOpacity(0.1))),
                                    icon: SvgPicture.asset(
                                      Assets.icons.update,
                                      height: 20,
                                      width: 20,
                                    )),
                                IconButton(
                                    onPressed: onPressDelete,
                                    tooltip: 'Delete',
                                    highlightColor:
                                        Colors.red.shade400.withOpacity(0.2),
                                    // style:  ButtonStyle(
                                    //     backgroundColor:
                                    //     MaterialStatePropertyAll(Colors.teal.withOpacity(0.1))),
                                    icon: SvgPicture.asset(
                                      Assets.icons.delete,
                                      height: 25,
                                      width: 25,
                                      colorFilter: const ColorFilter.mode(
                                          Colors.red, BlendMode.srcIn),
                                    ))
                              ],
                            )
                          : widget.summaryData.status == SummaryStatus.Loading
                              ? Container(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                      onPressed: onPressCancel,
                                      tooltip: 'Cancel',
                                      highlightColor:
                                          Colors.red.shade400.withOpacity(0.2),
                                      // style:  ButtonStyle(
                                      //     backgroundColor:
                                      //     MaterialStatePropertyAll(Colors.teal.withOpacity(0.1))),
                                      icon: const Icon(Icons.close)),
                                )
                              : Container(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
