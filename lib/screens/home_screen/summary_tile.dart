import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/screens/request_screen.dart';

import '../../bloc/settings/settings_bloc.dart';
import '../../gen/assets.gen.dart';
import '../../models/models.dart';
import '../summary_screen/summary_screen.dart';

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

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    setState(() {
      _notification = state;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      setState(() {
        _notification = WidgetsBinding.instance.lifecycleState!;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onPressSummaryTile() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SummaryScreen(summaryKey: widget.sharedLink)),
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
        return ((previous.summaries[widget.sharedLink]?.longSummaryStatus ==
                SummaryStatus.loading &&
            current.summaries[widget.sharedLink]?.longSummaryStatus ==
                SummaryStatus.complete));
      },
      listener: (context, state) {
        onSummaryLoad(
            title: state.summaries[widget.sharedLink]?.summaryPreview.title ??
                widget.sharedLink);
      },
      builder: (context, state) {
        final summaryData = state.summaries[widget.sharedLink];
        final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
        final String formattedDate = formatter.format(summaryData!.date);

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
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
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
              title: SizedBox(
                height: 80,
                child: AspectRatio(
                  aspectRatio: 3.5,
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(187, 247, 247, 1),
                    child: InkWell(
                      splashFactory: InkSplash.splashFactory,
                      highlightColor:
                          Theme.of(context).canvasColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        if (summaryData.longSummaryStatus ==
                            SummaryStatus.complete) {
                          onPressSummaryTile();
                        }
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
                                      horizontal: 2, vertical: 2),
                                  child: Hero(
                                    tag: summaryData.date,
                                    child: summaryData
                                                    .summaryPreview.imageUrl ==
                                                Assets.placeholderLogo.path ||
                                            summaryData
                                                    .summaryPreview.imageUrl ==
                                                null
                                        ? Image.asset(
                                            Assets.placeholderLogo.path)
                                        : CachedNetworkImage(
                                            imageUrl: summaryData
                                                .summaryPreview.imageUrl!,
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
                                  Container(
                                    width: MediaQuery.of(context).size.shortestSide < 550 ? double.infinity : 700,
                                    child: Text(
                                      summaryData.summaryPreview.title ??
                                          widget.sharedLink
                                              .replaceAll('https://', ''),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium?.copyWith(color: Colors.black),  
                                          
                                    ),
                                  ),
                                  SizedBox(height:3,),
                                  Text(
                                    formattedDate,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall?.copyWith(color: Colors.black), 
                                  ),
                                  ErrorMessage(
                                    summaryData: summaryData,
                                  ),
                                  Loader(
                                      onPressCancel: onPressCancel,
                                      summaryData: summaryData)
                                ],
                              ),
                            ),
                          ),
                          ErrorButtons(
                            summaryLink: widget.sharedLink,
                            summaryData: summaryData,
                          )
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

class ErrorButtons extends StatelessWidget {
  final String summaryLink;
  final SummaryData summaryData;
  const ErrorButtons(
      {super.key, required this.summaryData, required this.summaryLink});

  @override
  Widget build(BuildContext context) {
    void onPressRetry() {
      context
          .read<SummariesBloc>()
          .add(GetSummaryFromUrl(summaryUrl: summaryLink, fromShare: false));
      context
          .read<MixpanelBloc>()
          .add(SummaryUpgrade(url: summaryLink, fromShare: false));
    }

    void onPressReport() {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const RequestScreen(),
      ));
    }

    return AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  tooltip: 'Report a problem',
                  onPressed: onPressReport,
                  highlightColor: Colors.red.shade300.withOpacity(0.2),
                  padding: EdgeInsets.zero,
                  iconSize: 22,
                  visualDensity: VisualDensity.compact,
                  // constraints: BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // the '2023' part
                  ),
                  icon: SvgPicture.asset(
                    Assets.icons.danger,
                    width: 22,
                  )),
              IconButton(
                  tooltip: 'Retry',
                  onPressed: onPressRetry,
                  highlightColor: Colors.teal.withOpacity(0.2),
                  padding: EdgeInsets.zero,
                  iconSize: 22,
                  visualDensity: VisualDensity.compact,
                  // constraints: BoxConstraints(),
                  style: const ButtonStyle(
                    tapTargetSize:
                        MaterialTapTargetSize.shrinkWrap, // the '2023' part
                  ),
                  icon: SvgPicture.asset(
                    Assets.icons.update,
                    width: 22,
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).cardColor, BlendMode.srcIn),
                  )),
            ],
          ),
        ),
        secondChild: Container(),
        crossFadeState: summaryData.longSummaryStatus == SummaryStatus.error
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 500));
  }
}

class ErrorMessage extends StatelessWidget {
  final SummaryData summaryData;

  const ErrorMessage({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
        firstChild: Container(),
        secondChild: Column(
          children: [
            Text(
              summaryData.longSummary.summaryError ?? 'Some error',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12, height: 3, color: Colors.red.shade400),
            ),
          ],
        ),
        crossFadeState: summaryData.longSummaryStatus == SummaryStatus.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 500));
  }
}

class Loader extends StatefulWidget {
  final Function() onPressCancel;
  final SummaryData summaryData;
  const Loader(
      {super.key, required this.onPressCancel, required this.summaryData});

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
    return AnimatedCrossFade(
        firstChild: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(width: 10,),
            Text('${loadingText[textIndex]}    ',
                    style: const TextStyle(fontSize: 12, height: 3, color: Colors.black))
                .animate()
                .custom(
                    duration: 300.ms,
                    builder: (context, value, child) => Container(
                          child:
                              child, // child is the Text widget being animated
                        ))
          ],
        ),
        secondChild: Container(),
        crossFadeState:
            widget.summaryData.longSummaryStatus == SummaryStatus.loading
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 500));
  }
}
