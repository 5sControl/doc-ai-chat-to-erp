import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:styled_text/tags/styled_text_tag.dart';
import 'package:styled_text/widgets/styled_text.dart';
import 'package:summify/widgets/share_copy_button.dart';
import 'package:url_launcher/url_launcher.dart';

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
    final summaryText = summaryData.summary!
        .replaceFirst('Summary:', '<b>Summary:\n</b>')
        .replaceFirst('In-depth Analysis:', '<b>In-depth Analysis:\n</b>')
        .replaceFirst('Key Points:', '<b>Key Points:</b>')
        .replaceFirst('Additional Context:', '<b>Additional Context:\n</b>')
        .replaceFirst('Supporting Evidence:', '<b>Supporting Evidence:\n</b>')
        .replaceFirst('Implications or Conclusions:',
            '<b>Implications or Conclusions:\n</b>');

    const List<Effect<dynamic>> effects = [
      MoveEffect(
          end: Offset(0, 0),
          begin: Offset(0, 100),
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 350)),
      ShimmerEffect(delay: Duration(milliseconds: 350))
    ];

    void onPressDelete() {
      Navigator.of(context).pop();
      context
          .read<SharedLinksBloc>()
          .add(DeleteSharedLink(sharedLink: sharedLink));
    }

    void onPressBack() {
      Navigator.of(context).pushNamed('/');
    }

    void onPressLink() async {
      final Uri url = Uri.parse(sharedLink);
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
                  child: HeroImage(
                    summaryData: summaryData,
                  ),
                ),
                Header(
                  sharedLink: sharedLink,
                  displayLink: displayLink,
                  formattedDate: formattedDate,
                  onPressLink: onPressLink,
                  onPressBack: onPressBack,
                  onPressDelete: onPressDelete,
                )
              ],
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomCenter,
                children: [
                  Animate(
                    effects: effects,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 110, top: 10),
                        child: StyledText(
                          text: summaryText,
                          style: const TextStyle(fontSize: 16),
                          tags: {
                            'b': StyledTextTag(
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    height: 2)),
                          },
                        )),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        // transformAlignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(223, 252, 252, 1),
                                  Color.fromRGBO(223, 252, 252, 0),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [
                                  0.3,
                                  1,
                                ])),
                        padding: const EdgeInsets.all(15),
                        child: ShareAndCopyButton(
                          sharedLink: sharedLink,
                          summaryData: summaryData,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }
}

class Header extends StatelessWidget {
  final String displayLink;
  final String sharedLink;
  final String formattedDate;
  final VoidCallback onPressDelete;
  final VoidCallback onPressBack;
  final VoidCallback onPressLink;

  const Header(
      {super.key,
      required this.displayLink,
      required this.formattedDate,
      required this.onPressDelete,
      required this.onPressLink,
      required this.onPressBack,
      required this.sharedLink});

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
          UrlLink(
            sharedLink: sharedLink,
            onPressLink: onPressLink,
          )
        ],
      ),
    );
  }
}

class UrlLink extends StatefulWidget {
  final String sharedLink;

  final VoidCallback onPressLink;
  const UrlLink(
      {super.key, required this.sharedLink, required this.onPressLink});

  @override
  State<UrlLink> createState() => _UrlLinkState();
}

class _UrlLinkState extends State<UrlLink> {
  static const duration = Duration(milliseconds: 150);
  bool pressed = false;

  void onTapDown() {
    setState(() {
      pressed = true;
    });
  }

  void onTapUp() {
    Future.delayed(duration, () {
      setState(() {
        pressed = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.white,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapUp(),
      onTap: widget.onPressLink,
      child: Row(
        children: [
          Flexible(
            child: AnimatedDefaultTextStyle(
              duration: duration,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: pressed ? 15 : 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: const [
                    Shadow(
                        color: Colors.black,
                        blurRadius: 10,
                        offset: Offset(0, 0)),
                  ]),
              child: Text(
                widget.sharedLink,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class HeroImage extends StatelessWidget {
  final SummaryData summaryData;
  const HeroImage({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: summaryData.date,
      child: Stack(
        fit: StackFit.expand,
        children: [
          summaryData.imageUrl != null
              ? CachedNetworkImage(
                  imageUrl: summaryData.imageUrl ?? '',
                  fit: BoxFit.cover,
                  color: Colors.black54,
                  fadeInCurve: Curves.ease,
                  colorBlendMode: BlendMode.colorBurn,
                )
              : Image.asset(Assets.placeholderLogo.path),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
