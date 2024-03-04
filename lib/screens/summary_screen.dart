import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
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
    void onPressDelete() {
      Navigator.of(context).pop();
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: sharedLink));
    }

    void onPressBack() {
      Navigator.of(context).pop();
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
              // clipBehavior: Clip.hardEdge,
              children: [
                Positioned.fill(
                  child: HeroImage(
                    summaryData: summaryData,
                  ),
                ),
                Header(
                  displayLink: displayLink,
                  formattedDate: formattedDate,
                  onPressBack: onPressBack,
                  onPressDelete: onPressDelete,
                )
              ],
            ),
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Text(
                      summaryData.summary!,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ))),
            Padding(
              padding: const EdgeInsets.all(15),
              child: ShareButton(
                sharedLink: sharedLink,
                summaryData: summaryData,
              ),
            )
          ],
        )),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final String displayLink;
  final String formattedDate;
  final VoidCallback onPressDelete;
  final VoidCallback onPressBack;

  const Header(
      {super.key,
      required this.displayLink,
      required this.formattedDate,
      required this.onPressDelete,
      required this.onPressBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: 15,
          right: 15,
          bottom: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: onPressBack,
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: Colors.white,
              ),
              IconButton(
                onPressed: onPressDelete,
                icon: SvgPicture.asset(Assets.icons.delete),
                color: Colors.white,
              )
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              displayLink,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 0)),
                  ]),
            ),
          ),
          const Divider(color: Colors.transparent),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  decoration: const BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer,
                        offset: Offset(0, 0)),
                  ]),
                  padding: const EdgeInsets.only(right: 7),
                  child: SvgPicture.asset(Assets.icons.clock)),
              Text(
                formattedDate,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(0, 0)),
                    ]),
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
                      color: Colors.white,
                      shadows: [
                        Shadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0, 0)),
                      ]),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.white,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  final SummaryData summaryData;
  final String sharedLink;
  const ShareButton(
      {super.key, required this.summaryData, required this.sharedLink});

  @override
  Widget build(BuildContext context) {
    void onPressShare() {
      final box = context.findRenderObject() as RenderBox?;
      Share.share(
        '$sharedLink \n\n ${summaryData.summary}',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }

    return GestureDetector(
      onTap: onPressShare,
      child: Container(
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
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Padding(
                padding: EdgeInsets.only(left: 7),
                child: Icon(
                  Icons.arrow_upward_sharp,
                  color: Colors.white,
                ))
          ],
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
    return ClipRect(
      child: Hero(
          tag: summaryData.date,
          child: summaryData.imageUrl == null
              ? ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Image.asset(
                    Assets.placeholderLogo.path,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                )
              : ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: CachedNetworkImage(
                    imageUrl: summaryData.imageUrl!,
                    fit: BoxFit.cover,
                    color: Colors.black54,
                    colorBlendMode: BlendMode.colorBurn,
                  ),
                )),
    );
  }
}
