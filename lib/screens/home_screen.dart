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
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
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
              )
            ],
          )),
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


