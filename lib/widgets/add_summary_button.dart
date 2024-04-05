import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/gen/assets.gen.dart';

import '../bloc/mixpanel/mixpanel_bloc.dart';
import '../screens/modal_screens/text_screen.dart';
import '../screens/modal_screens/ulr_screen.dart';
import '../screens/subscription_screen.dart';

final Map<String, String> buttons = {
  'Link': Assets.icons.url,
  '_': '',
  'File': Assets.icons.file,
  '__': '',
  'Text': Assets.icons.text,
};

class AddSummaryButton extends StatelessWidget {
  const AddSummaryButton({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressURl() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const UrlModalScreen();
        },
      );
    }

    void onPressText() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black54,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const TextModalScreen();
        },
      );
    }

    void onPressOpenFile() async {
      final DateFormat formatter = DateFormat('MM.dd.yy');
      final thisDay = formatter.format(DateTime.now());
      final limit = context.read<SummariesBloc>().state.dailyLimit;
      final daySummaries =
          context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 15;

      FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docs', 'rtf', 'txt', 'epub'],
          allowMultiple: false);

      Future.delayed(const Duration(milliseconds: 10), () async {
        if (daySummaries >= limit) {
          showCupertinoModalBottomSheet(
            context: context,
            expand: false,
            bounce: false,
            barrierColor: Colors.black54,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return const SubscriptionScreen();
            },
          );
          context
              .read<MixpanelBloc>()
              .add(LimitReached(resource: result?.paths[0] ?? 'file', registrated: false));
        } else if (result?.paths.isNotEmpty != null) {
          final fileName = result!.paths[0]?.split('/').last;
          context.read<SummariesBloc>().add(GetSummaryFromFile(
                fileName: fileName!,
                filePath: result.paths[0]!,
            fromShare: false
              ));
        }
      });
    }

    void onPressButton({required String title}) {
      switch (title) {
        case 'Link':
          onPressURl();
          context.read<MixpanelBloc>().add(const SelectOption(option: 'link'));
        case 'File':
          onPressOpenFile();
          context.read<MixpanelBloc>().add(const SelectOption(option: 'file'));
        case 'Text':
          onPressText();
          context.read<MixpanelBloc>().add(const SelectOption(option: 'text'));
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white54,
                width: 5,
                strokeAlign: BorderSide.strokeAlignCenter,
              ),
              color: const Color.fromRGBO(30, 188, 183, 0.8),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: buttons.keys.map((button) {
              if (button == '_' || button == '__') {
                return Container(
                  width: 1,
                  height: 35,
                  color: Colors.white,
                );
              }
              return AddButton(
                title: button,
                icon: buttons[button]!,
                onPressButton: onPressButton,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  final String title;
  final String icon;
  final Function({required String title}) onPressButton;
  const AddButton(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressButton});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton> {
  static const duration = Duration(milliseconds: 150);
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

  void onTap() {
    Future.delayed(duration, () {
      widget.onPressButton(title: widget.title);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: () => onTapUp(),
      child: AnimatedContainer(
        color: Colors.transparent,
        duration: duration,
        padding:
            EdgeInsets.symmetric(horizontal: tapped ? 15 : 10, vertical: 2),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, bottom: 5, top: 10),
              child: SvgPicture.asset(
                widget.icon,
                height: tapped ? 27 : 25,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            Text(
              widget.title,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

// class AddSummaryButton extends StatefulWidget {
//   const AddSummaryButton({super.key});
//
//   @override
//   State<AddSummaryButton> createState() => _AddSummaryButtonState();
// }
//
// class _AddSummaryButtonState extends State<AddSummaryButton> {
//   // static const duration = Duration(milliseconds: 300);
//   bool _isOpen = false;
//   // bool tappedUrl = false;
//   // bool tappedFile = false;
//   // bool tappedText = false;
//
//   static const XTypeGroup typeGroup = XTypeGroup(
//     label: '',
//     extensions: <String>['txt', 'docx', 'pdf'],
//     uniformTypeIdentifiers: <String>['public.data'],
//   );
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   void onToggleOpen() {
//     setState(() {
//       _isOpen = !_isOpen;
//     });
//   }
//
//   // void onTapDown(String target) {
//   //   setState(() {
//   //     if (target == 'url') {
//   //       tappedUrl = true;
//   //     }
//   //     if (target == 'file') {
//   //       tappedFile = true;
//   //     }
//   //     if (target == 'text') {
//   //       tappedText = true;
//   //     }
//   //   });
//   // }
//   //
//   // void onTapUp(String target) {
//   //   Future.delayed(duration, () {
//   //     setState(() {
//   //       if (target == 'url') {
//   //         tappedUrl = false;
//   //       }
//   //       if (target == 'file') {
//   //         tappedFile = false;
//   //       }
//   //       if (target == 'text') {
//   //         tappedText = false;
//   //       }
//   //     });
//   //   });
//   // }
//
//   void onPressURl() {
//     showCupertinoModalBottomSheet(
//       context: context,
//       expand: false,
//       bounce: false,
//       barrierColor: Colors.black54,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return const UrlModalScreen();
//       },
//     );
//   }
//
//   void onPressText() {
//     showCupertinoModalBottomSheet(
//       context: context,
//       expand: false,
//       bounce: false,
//       barrierColor: Colors.black54,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return const TextModalScreen();
//       },
//     );
//   }
//
//   void onPressOpenFile() async {
//     final XFile? file =
//         await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
//     if (file != null) {
//       context.read<SharedLinksBloc>().add(SaveFile(
//             fileName: file.name,
//             filePath: file.path,
//           ));
//     }
//     // print(file?.name);
//     // print(file?.path);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onToggleOpen,
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(!_isOpen ? 50 : 8),
//         clipBehavior: Clip.hardEdge,
//         child: BackdropFilter(
//           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//           child: AnimatedContainer(
//             // height: 80,
//             clipBehavior: Clip.hardEdge,
//             duration: const Duration(milliseconds: 400),
//             // alignment: !_isOpen ? Alignment.centerRight : Alignment.center,
//             padding: EdgeInsets.symmetric(
//                 horizontal: !_isOpen ? 10 : 0, vertical: !_isOpen ? 10 : 0),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(!_isOpen ? 50 : 8),
//                 color: Colors.teal.shade500.withOpacity(0.6)),
//             child: AnimatedCrossFade(
//               firstChild: const Icon(
//                 Icons.add,
//                 color: Colors.white,
//                 size: 35,
//               ),
//               secondChild: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     child: GestureDetector(
//                         onTap: onPressURl,
//                         // onTapDown: (_) => onTapDown('url'),
//                         // onTapUp: (_) => onTapDown('url'),
//                         // onTapCancel: () => onTapUp('url'),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.max,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             SvgPicture.asset(
//                               Assets.icons.url,
//                               height: 25,
//                               width: 25,
//                               fit: BoxFit.contain,
//                               colorFilter: const ColorFilter.mode(
//                                   Colors.white, BlendMode.srcIn),
//                             ),
//                             const Text(
//                               'Link',
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         )),
//                   ),
//                   Container(
//                     color: Colors.white,
//                     width: 1,
//                     height: 40,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     child: GestureDetector(
//                         onTap: onPressOpenFile,
//                         child: Column(
//                           children: [
//                             SvgPicture.asset(
//                               Assets.icons.file,
//                               height: 25,
//                               colorFilter: const ColorFilter.mode(
//                                   Colors.white, BlendMode.srcIn),
//                             ),
//                             const Text(
//                               'File',
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         )),
//                   ),
//                   Container(
//                     color: Colors.white,
//                     width: 1,
//                     height: 40,
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 20, vertical: 10),
//                     child: GestureDetector(
//                         onTap: onPressText,
//                         child: Column(
//                           children: [
//                             SvgPicture.asset(
//                               Assets.icons.text,
//                               height: 25,
//                               colorFilter: const ColorFilter.mode(
//                                   Colors.white, BlendMode.srcIn),
//                             ),
//                             const Text(
//                               'Text',
//                               style: TextStyle(color: Colors.white),
//                             )
//                           ],
//                         )),
//                   ),
//                 ],
//               ),
//               duration: Duration(milliseconds: 400),
//               crossFadeState: !_isOpen
//                   ? CrossFadeState.showFirst
//                   : CrossFadeState.showSecond,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
