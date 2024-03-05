import 'dart:ui';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/gen/assets.gen.dart';

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
            // height: 80,
            clipBehavior: Clip.hardEdge,
            duration: const Duration(milliseconds: 400),
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
                  IconButton(
                      onPressed: onPressURl,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      icon: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset(Assets.icons.url, height: 25, width: 25, fit: BoxFit.contain),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Link',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )),
                  Container(
                    color: Colors.white,
                    width: 1,
                    height: 40,
                  ),
                  IconButton(
                      onPressed: onPressOpenFile,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      icon: Column(
                        children: [
                          SvgPicture.asset(Assets.icons.file, height: 25),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'File',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )),
                  Container(
                    color: Colors.white,
                    width: 1,
                    height: 40,
                  ),
                  IconButton(
                      onPressed: onPressText,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      icon: Column(
                        children: [
                          SvgPicture.asset(
                            Assets.icons.text,
                            height: 25,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              'Link',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )),
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
