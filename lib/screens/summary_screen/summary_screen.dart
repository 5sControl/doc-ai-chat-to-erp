import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/helpers/get_transformed_text.dart';
import 'package:summify/screens/modal_screens/rate_summary_screen.dart';
import 'package:summify/screens/summary_screen/summary_hero_image.dart';
import 'package:summify/widgets/share_copy_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../models/models.dart';
import '../../widgets/backgroung_gradient.dart';
import 'custom_tab_bar.dart';
import 'header.dart';

class SummaryScreen extends StatefulWidget {
  final String summaryKey;
  const SummaryScreen({
    super.key,
    required this.summaryKey,
  });

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    if (context
        .read<SummariesBloc>()
        .state
        .ratedSummaries
        .contains(widget.summaryKey)) {
      context
          .read<MixpanelBloc>()
          .add(ShowSummaryAgain(resource: widget.summaryKey));
    }
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummariesBloc, SummariesState>(
      builder: (context, state) {
        final summaryData = state.summaries[widget.summaryKey]!;
        final displayLink = summaryData.summaryPreview.title ??
            widget.summaryKey.replaceAll('https://', '');

        final DateFormat formatter = DateFormat('HH:mm E, MM.dd.yy');
        final String formattedDate = formatter.format(summaryData.date);

        final briefSummaryText = getTransformedText(
            text: summaryData.shortSummary.summaryText ?? '');

        final deepSummaryText =
            getTransformedText(text: summaryData.longSummary.summaryText ?? '');

        void showRateScreen() {
          showMaterialModalBottomSheet(
            context: context,
            expand: false,
            bounce: false,
            barrierColor: Colors.black54,
            backgroundColor: Colors.transparent,
            enableDrag: false,
            builder: (context) {
              return RateSummaryScreen(
                summaryLink: widget.summaryKey,
              );
            },
          );
        }

        void onPressDelete() {
          Navigator.of(context).pop();
          Future.delayed(const Duration(milliseconds: 300), () {
            context
                .read<SummariesBloc>()
                .add(DeleteSummary(summaryUrl: widget.summaryKey));
          });
        }

        void onPressBack() {
          if (!state.ratedSummaries.contains(widget.summaryKey)) {
            showRateScreen();
          } else {
            Navigator.of(context).pop();
          }
        }

        void onPressLink() async {
          final Uri url = Uri.parse(widget.summaryKey);
          if (!await launchUrl(url)) {}
        }

        return Stack(
          children: [
            const BackgroundGradient(),
            Container(color: Colors.white38),
            Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Stack(
                    fit: StackFit.loose,
                    children: [
                      Positioned.fill(
                        child: SummaryHeroImage(
                          summaryData: summaryData,
                        ),
                      ),
                      Header(
                        sharedLink: widget.summaryKey,
                        displayLink: displayLink,
                        formattedDate: formattedDate,
                        onPressLink: onPressLink,
                        onPressBack: onPressBack,
                        onPressDelete: onPressDelete,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        TabBarView(
                          controller: _tabController,
                          children: [
                            SummaryTextContainer(
                              summaryText: briefSummaryText,
                              summary: summaryData.shortSummary,
                              summaryStatus: summaryData.shortSummaryStatus,
                            ),
                            SummaryTextContainer(
                              summaryText: deepSummaryText,
                              summary: summaryData.longSummary,
                              summaryStatus: summaryData.longSummaryStatus,
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(223, 252, 252, 0),
                                Color.fromRGBO(191, 249, 249, 1),
                                Color.fromRGBO(191, 249, 249, 1),
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            )),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child:
                                  customTabBar(tabController: _tabController),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              extendBody: true,
              bottomNavigationBar: ShareAndCopyButton(
                sharedLink: widget.summaryKey,
                summaryData: summaryData,
              ),
            ),
          ],
        );
      },
    );
  }
}

class SummaryTextContainer extends StatelessWidget {
  final String summaryText;
  final Summary summary;
  final SummaryStatus summaryStatus;
  const SummaryTextContainer(
      {super.key,
      required this.summaryText,
      required this.summary,
      required this.summaryStatus});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    return Scrollbar(
      controller: scrollController,
      child: SingleChildScrollView(
        controller: scrollController,
        padding:
            const EdgeInsets.only(top: 50, bottom: 90, left: 15, right: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        child: SelectableText.rich(
          TextSpan(
            text: summaryText,
            style: DefaultTextStyle.of(context).style,
            spellOut: true,
          ),
        ),
      ),
    );
  }
}
