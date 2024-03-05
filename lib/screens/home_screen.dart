import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../widgets/summary_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Stack(
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
                child: AppBar(
                    elevation: 0,
                    forceMaterialTransparency: true,
                    shadowColor: null,
                    toolbarHeight: 50,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    title: Padding(
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
                            style:
                                TextStyle(color: Color.fromRGBO(6, 49, 57, 1)),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<SharedLinksBloc, SharedLinksState>(
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
    );
  }
}
