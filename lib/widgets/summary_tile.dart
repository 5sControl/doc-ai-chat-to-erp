import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';

import '../bloc/settings/settings_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../screens/summary_screen.dart';

class SummaryTile extends StatefulWidget {
  final String sharedLink;
  // final bool isNew;

  const SummaryTile({
    super.key,
    required this.sharedLink,
  });

  @override
  State<SummaryTile> createState() => _SummaryTileState();
}

class _SummaryTileState extends State<SummaryTile> with WidgetsBindingObserver {
  late AppLifecycleState _notification;
  static const duration = Duration(milliseconds: 300);
  bool tapped = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    setState(() {
      _notification = state;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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

  void onPressSummaryTile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SummaryScreen(sharedLink: widget.sharedLink)),
    );
    context.read<MixpanelBloc>().add(const OpenSummary());
  }

  void onSummaryLoad({required String title}) {
    if (_notification == AppLifecycleState.paused ||
        _notification == AppLifecycleState.inactive ||
        _notification == AppLifecycleState.hidden) {
      context.read<SettingsBloc>().add(
          SendNotify(title: title, description: 'Your summary already done'));
    }
    onPressSummaryTile();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SummariesBloc, SummariesState>(
      listenWhen: (previous, current) {
        return previous.summaries[widget.sharedLink]?.status ==
                SummaryStatus.Loading &&
            current.summaries[widget.sharedLink]?.status ==
                SummaryStatus.Complete;
      },
      listener: (context, state) {
        onSummaryLoad(
            title:
                state.summaries[widget.sharedLink]?.title ?? widget.sharedLink);
      },
      builder: (context, state) {
        final summaryData = state.summaries[widget.sharedLink]!;

        void onPressRetry() {
          context.read<SummariesBloc>().add(GetSummaryFromUrl(
              summaryUrl: widget.sharedLink, fromShare: false));
          context
              .read<MixpanelBloc>()
              .add(SummaryUpgrade(resource: widget.sharedLink));
        }

        void onPressDelete() {
          context
              .read<SummariesBloc>()
              .add(DeleteSummary(summaryUrl: widget.sharedLink));
        }

        void onPressCancel() {
          context
              .read<SummariesBloc>()
              .add(CancelRequest(sharedLink: widget.sharedLink));
        }

        return Builder(builder: (context) {
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
              margin: const EdgeInsets.only(
                  left: 10, right: 10, bottom: 30, top: 20),
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
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn)),
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
                          onPressSummaryTile();
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
                                    child: summaryData.imageUrl ==
                                            Assets.placeholderLogo.path
                                        ? Image.asset(
                                            Assets.placeholderLogo.path)
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
                                    summaryData.title ??
                                        widget.sharedLink
                                            .replaceAll('https://', ''),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    summaryData.formattedDate,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  AnimatedCrossFade(
                                      firstChild: Loader(
                                        onPressCancel: onPressCancel,
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
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
              style: TextStyle(
                  fontSize: 12, height: 1, color: Colors.red.shade400),
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

class Loader extends StatefulWidget {
  final Function() onPressCancel;
  const Loader({super.key, required this.onPressCancel});

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  static const List<String> loadingText = [
    'Accepted',
    'Downloaded',
    'Processing',
    'Analyzing',
    'Connecting Model',
    'AI Processing',
    'Improving',
    'Summarizing',
    'Reviewing',
    'Formatting',
    'Finalizing',
    'Delivering',
  ];
  int textIndex = 0;
  late Timer t;

  void incText() {
    setState(() {
      if (textIndex >= 11) {
        textIndex = 0;
      } else {
        textIndex = textIndex + 1;
      }
    });
  }

  @override
  void initState() {
    t = Timer.periodic(const Duration(seconds: 2), (timer) => incText());
    super.initState();
  }

  @override
  void dispose() {
    t.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
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
            ),
            IconButton(
                onPressed: widget.onPressCancel,
                iconSize: 25,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.stop_circle_outlined))
          ],
        ),
        Text('${loadingText[textIndex]}    ',
                style: const TextStyle(fontSize: 12, height: -1))
            .animate()
            .custom(
                duration: 300.ms,
                builder: (context, value, child) => Container(
                      child: child, // child is the Text widget being animated
                    ))
      ],
    );
  }
}
