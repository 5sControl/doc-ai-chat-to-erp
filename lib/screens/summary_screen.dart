import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../models/models.dart';
import '../widgets/backgroung_gradient.dart';

class SummaryScreen extends StatelessWidget {
  final SummaryData summaryData;
  final String displayLink;
  final String formattedDate;
  final String sharedLink;
  const SummaryScreen(
      {super.key,
      required this.summaryData,
      required this.formattedDate,
      required this.sharedLink,
      required this.displayLink});

  @override
  Widget build(BuildContext context) {
    void onPressDelete(sharedLink) {
      Navigator.of(context).pop();
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: sharedLink));
    }

    return Stack(
      children: [
        const BackgroundGradient(),
        HeroImage(summaryData: summaryData),
        Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    onPressDelete(sharedLink);
                  },
                  icon: const Icon(Icons.delete_forever_outlined),
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
                  displayLink,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                const Divider(color: Colors.transparent),
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
                const Divider(color: Colors.transparent),
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
                    const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    )
                  ],
                ),
                SummaryTabs(
                  summaryData: summaryData,
                ),
                const ShareButton()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
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
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(
                Icons.arrow_upward_sharp,
                color: Colors.white,
              ))
        ],
      ),
    );
  }
}

class SummaryTabs extends StatelessWidget {
  final SummaryData summaryData;
  const SummaryTabs({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size(150.0, 50.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(8)),
                child: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  dividerColor: Colors.transparent,
                  labelPadding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.center,
                  tabs: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Tab(text: 'Action Points', height: 30),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Tab(
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
                children: summaryData.summary?.keyPoints
                        .map((e) => Text(
                              '- $e',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ))
                        .toList() ??
                    [],
              ),
              Container(
                alignment: Alignment.center,
                child: Text(summaryData.summary?.summary ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  final SummaryData summaryData;
  const HeroImage({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: AspectRatio(
        aspectRatio: 1.3,
        child: Hero(
          tag: summaryData.title!,
          child: Material(
            color: Colors.transparent,
            child: CachedNetworkImage(
              imageUrl: summaryData.imageUrl ?? '',
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    scale: 1,
                    fit: BoxFit.cover,
                    // colorFilter:
                    // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(
                  color: Colors.white70,
                  strokeCap: StrokeCap.round,
                ),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                color: Colors.red.shade400,
              ),
              // width: 120,
              // height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
