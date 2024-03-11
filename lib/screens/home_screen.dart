import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/screens/modal_screens/info_screen.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../widgets/summary_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          return const InfoScreen();
        },
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 35,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      Assets.icons.logo,
                      height: 30,
                      width: 30,
                      colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(6, 49, 57, 1), BlendMode.srcIn),
                    ),
                    const Text(
                      '  Summify',
                      style: TextStyle(color: Color.fromRGBO(6, 49, 57, 1)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(7),
                width: 35,
                height: 35,
                child: IconButton(
                  onPressed: onPressInfo,
                  padding: EdgeInsets.zero,
                  icon: SvgPicture.asset(
                    Assets.icons.info,
                    height: 30,
                    width: 30,
                    colorFilter: const ColorFilter.mode(
                        Color.fromRGBO(6, 49, 57, 1), BlendMode.srcIn),
                  ),
                ),
              )
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: BlocBuilder<SharedLinksBloc, SharedLinksState>(
            builder: (context, sharedLinksState) {
          return ListView.builder(
            itemCount: sharedLinksState.savedLinks.length,
            itemBuilder: (context, index) {
              final sharedLink = sharedLinksState.savedLinks.keys
                  .toList()
                  .reversed
                  .toList()[index];
              final SummaryData summaryData =
                  sharedLinksState.savedLinks[sharedLink]!;
              return SummaryTile(
                sharedLink: sharedLink,
                summaryData: summaryData,
              );
            },
          );
        }),
      ),
    );
  }
}
