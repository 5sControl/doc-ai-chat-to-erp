import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/summary_screen/info_modal/extension_modal.dart';
import 'package:summify/screens/summary_screen/info_modal/info_modal.dart';
import 'package:summify/screens/summary_screen/info_modal/text_size_modal.dart';

import '../../bloc/mixpanel/mixpanel_bloc.dart';
import '../../gen/assets.gen.dart';

class Header extends StatelessWidget {
  final String displayLink;
  final String sharedLink;
  final String formattedDate;
  final VoidCallback onPressBack;
  final VoidCallback onPressLink;
  final SummaryData summaryData;

  const Header(
      {super.key,
      required this.displayLink,
      required this.formattedDate,
      required this.onPressLink,
      required this.onPressBack,
      required this.sharedLink,
      required this.summaryData});

  @override
  Widget build(BuildContext context) {
    void onPressInfo() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return InfoModal(
            summaryData: summaryData,
          );
        },
      );
    }

    void onPressTextSize() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return TextSizeModal();
        },
      );
    }

    void onPressDesktop() {
      showMaterialModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (context) {
          return const ExtensionModal();
        },
      );
      context.read<MixpanelBloc>().add(const OpenSummifyExtensionModal());
    }

    return Container(
      height: 250,
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
              Row(
                children: [
                  IconButton(
                    onPressed: onPressInfo,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.i,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: onPressTextSize,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.textScale,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    color: Colors.white,
                  ),
                  IconButton(
                    onPressed: onPressDesktop,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    icon: SvgPicture.asset(
                      Assets.icons.desctop,
                      colorFilter:
                          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    color: Colors.white,
                  )
                ],
              )
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
                onPressed: onPressLink,
                child: Text(
                  displayLink,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
          ),
          const Divider(color: Colors.transparent),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              Container(
                  padding: const EdgeInsets.only(right: 7),
                  child: SvgPicture.asset(Assets.icons.clock)),
              Text(
                formattedDate,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class UrlLink extends StatefulWidget {
//   final String sharedLink;
//
//   final VoidCallback onPressLink;
//   const UrlLink(
//       {super.key, required this.sharedLink, required this.onPressLink});
//
//   @override
//   State<UrlLink> createState() => _UrlLinkState();
// }
//
// class _UrlLinkState extends State<UrlLink> {
//   static const duration = Duration(milliseconds: 150);
//   bool pressed = false;
//
//   void onTapDown() {
//     setState(() {
//       pressed = true;
//     });
//   }
//
//   void onTapUp() {
//     Future.delayed(duration, () {
//       setState(() {
//         pressed = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       highlightColor: Colors.white,
//       onTapDown: (_) => onTapDown(),
//       onTapUp: (_) => onTapUp(),
//       onTapCancel: () => onTapUp(),
//       onTap: widget.onPressLink,
//       child: Row(
//         children: [
//           Flexible(
//             child: AnimatedDefaultTextStyle(
//               duration: duration,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: pressed ? 15 : 16,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.white,
//               ),
//               child: Text(
//                 widget.sharedLink,
//               ),
//             ),
//           ),
//           const Icon(
//             Icons.keyboard_arrow_right,
//             color: Colors.white,
//           )
//         ],
//       ),
//     );
//   }
// }
