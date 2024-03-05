import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../screens/modal_screens/text_screen.dart';
import '../screens/modal_screens/ulr_screen.dart';

class AddSummaryButton extends StatefulWidget {
  const AddSummaryButton({super.key});

  @override
  State<AddSummaryButton> createState() => _AddSummaryButtonState();
}

class _AddSummaryButtonState extends State<AddSummaryButton> {
  bool _isOpen = false;
  static const XTypeGroup typeGroup = XTypeGroup(
    label: '',
    extensions: <String>['txt', 'docx', 'pdf'],
    uniformTypeIdentifiers: <String>['public.data'],
  );

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void onToggleOpen() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

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
    final XFile? file =
    await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
    if (file != null) {
      context.read<SharedLinksBloc>().add(SaveFile(
        fileName: file.name,
        filePath: file.path,
      ));
    }
    // print(file?.name);
    // print(file?.path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggleOpen,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(!_isOpen ? 50 : 8),
        clipBehavior: Clip.hardEdge,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            clipBehavior: Clip.hardEdge,
            duration: Duration(milliseconds: 400),
            // alignment: !_isOpen ? Alignment.centerRight : Alignment.center,
            padding: EdgeInsets.symmetric(
                horizontal: !_isOpen ? 10 : 0, vertical: !_isOpen ? 10 : 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(!_isOpen ? 50 : 8),
                color: Colors.teal.shade500.withOpacity(0.6)),
            child: AnimatedCrossFade(
              firstChild: const Icon(
                Icons.add,
                color: Colors.white,
                size: 35,
              ),
              secondChild: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: onPressURl,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: SvgPicture.asset('assets/icons/url.svg'),
                      )),
                  Container(
                    color: Colors.white,
                    width: 1,
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: onPressOpenFile,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 15),
                      child: SvgPicture.asset('assets/icons/file.svg'),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: 1,
                    height: 40,
                  ),
                  GestureDetector(
                    onTap: onPressText,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: SvgPicture.asset('assets/icons/text.svg')),
                  ),


                ],
              ),
              duration: Duration(milliseconds: 400),
              crossFadeState: !_isOpen
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
            ),
          ),
        ),
      ),
    );
  }
}