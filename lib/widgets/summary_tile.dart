import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
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
  static const duration = Duration(milliseconds: 300);
  bool tapped = false;

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
    final summaryData = widget.summaryData;
    final displayLink = widget.sharedLink.replaceAll('https://', '');
    final summaryDate = summaryData.date;
    final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
    final String formattedDate = formatter.format(summaryDate);

    void onPressSharedItem() {
      context
          .read<SharedLinksBloc>()
          .add(SetSummaryOpened(sharedLink: widget.sharedLink));

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
      context
          .read<SharedLinksBloc>()
          .add(CancelRequest(sharedLink: widget.sharedLink));
    }

    return Dismissible(
      behavior: HitTestBehavior.translucent,
      key: Key(widget.sharedLink),
      onDismissed: (direction) {
        onPressDelete();
      },
      direction: DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: 0.5},
      movementDuration: const Duration(milliseconds: 1000),
      dragStartBehavior: DragStartBehavior.start,
      background: Container(
        margin:
            const EdgeInsets.only(left: 10, right: 10, bottom: 30, top: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
            color: const Color.fromRGBO(4, 49, 57, 1),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              ' Delete',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SvgPicture.asset(Assets.icons.delete,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ],
        ),
      ),
      resizeDuration: const Duration(milliseconds: 600),
      child: ListTile(
        leading: null,
        trailing: null,
        minVerticalPadding: 0,
        minLeadingWidth: 0,
        horizontalTitleGap: 0,
        contentPadding:
            const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
        title: AnimatedScale(
          scale: tapped ? 0.98 : 1,
          duration: duration,
          child: AspectRatio(
            aspectRatio: 3.5,
            child: AnimatedContainer(
              duration: duration,
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
              // clipBehavior: Clip.hardEdge,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  if (summaryData.status == SummaryStatus.Complete) {
                    onPressSharedItem();
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
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Hero(
                              tag: summaryData.date,
                              child: summaryData.imageUrl == null
                                  ? Image.asset(Assets.placeholderLogo.path)
                                  : CachedNetworkImage(
                                      imageUrl: summaryData.imageUrl!,
                                      fit: BoxFit.cover,
                                    ),
                            ))),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              summaryData.title ?? displayLink,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              formattedDate,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                            AnimatedCrossFade(
                                firstChild: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Loader(),
                                        IconButton(
                                            onPressed: onPressCancel,
                                            iconSize: 25,
                                            visualDensity:
                                                VisualDensity.compact,
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(
                                                Icons.stop_circle_outlined))
                                      ],
                                    ),
                                    const Text(
                                      'Loading...     ',
                                      style: TextStyle(
                                          fontSize: 12, height: -1),
                                    )
                                  ],
                                ),
                                secondChild: summaryData.error != null
                                    ? ErrorMessage(
                                        error: summaryData.error!,
                                        onPressRetry: onPressRetry,
                                      )
                                    : Container(),
                                crossFadeState: summaryData.status ==
                                        SummaryStatus.Loading
                                    ? CrossFadeState.showFirst
                                    : CrossFadeState.showSecond,
                                duration: duration)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: summaryData.opened == false &&
                              summaryData.status == SummaryStatus.Complete
                          ? const Padding(
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Icons.check,
                                color: Colors.teal,
                                size: 30,
                              ),
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

class ErrorMessage extends StatelessWidget {
  final String error;
  final VoidCallback onPressRetry;

  const ErrorMessage(
      {super.key, required this.error, required this.onPressRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
                child: Text(
              'Summarize error: $error',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, height: 1),
            )),
            IconButton(
                tooltip: 'Retry',
                onPressed: onPressRetry,
                highlightColor: Colors.teal,
                padding: const EdgeInsets.all(10),
                icon: SvgPicture.asset(
                  Assets.icons.update,
                  height: 25,
                  width: 25,
                )),
          ],
        ),
      ],
    );
  }
}

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        height: 10,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.teal.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: const LinearProgressIndicator(
          color: Colors.teal,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
