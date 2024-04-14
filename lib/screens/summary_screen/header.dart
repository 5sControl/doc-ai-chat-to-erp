import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../gen/assets.gen.dart';

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
          ),
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