import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/models.dart';
import '../widgets/backgroung_gradient.dart';

class SummaryScreen extends StatelessWidget {
  final Summary summary;
  final String displayLink;
  final String formattedDate;
  final String sharedLink;
  const SummaryScreen(
      {super.key,
      required this.summary,
      required this.formattedDate,
      required this.sharedLink,
      required this.displayLink});

  @override
  Widget build(BuildContext context) {
    // final displayLink = sharedLink.replaceAll('https://', '');
    return Stack(
      children: [
        const BackgroundGradient(),
        Scaffold(
          appBar: AppBar(
            title: const Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.white,
                )
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Text(
                  summary.supportingEvidence[0],
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Divider(color: Colors.transparent),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: SvgPicture.asset('assets/icons/clock.svg')),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ],
                ),
                Divider(color: Colors.transparent),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayLink,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    )
                  ],
                ),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Scaffold(
                      appBar: AppBar(
                        toolbarHeight: 0,
                        bottom: PreferredSize(
                          preferredSize: Size(150.0, 50.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(8)),
                            child: TabBar(
                              labelColor: Colors.white,
                              unselectedLabelColor: Colors.black,
                              dividerColor: Colors.transparent,
                              labelPadding: EdgeInsets.zero,
                              // padding: EdgeInsets.zero,
                              // indicatorPadding: EdgeInsets.zero,

                              // indicator: BoxDecoration(
                              //   color: Colors.teal.shade900,borderRadius: BorderRadius.circular(12)
                              // ),
                              tabAlignment: TabAlignment.center,
                              tabs: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: new Tab(
                                      text: 'Action Points', height: 30),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: new Tab(
                                    text: 'Summary',
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: summary.keyPoints
                                .map((e) => Text(
                                      '- $e',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ))
                                .toList(),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(summary.summary,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(4, 49, 57, 1),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Share',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_upward_sharp,
                            color: Colors.white,
                          ))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
