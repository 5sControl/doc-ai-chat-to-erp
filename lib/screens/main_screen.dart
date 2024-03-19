import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';

import 'package:summify/bloc/shared_links/shared_links_bloc.dart';
import 'package:summify/screens/account_screen.dart';
import 'package:summify/screens/home_screen.dart';

import '../widgets/add_summary_button.dart';
import '../widgets/backgroung_gradient.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late StreamSubscription intentMediaStreamSubscription;

  void saveLink(String summaryLink) async {
    print('asdasdasdasd');
    context
        .read<SharedLinksBloc>()
        .add(SaveSharedLink(sharedLink: summaryLink));
    Navigator.of(context).pushNamed('/');
  }

  @override
  void initState() {
    super.initState();
    intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          print(
            'Shared:${value?.map((f) => f.path).join(',') ?? ''}',
          );
        }
      },
      onError: (err) {
        debugPrint('getIntentDataStream error: $err');
      },
    );

    intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
      (String value) {
        saveLink(value);
      },
      onError: (err) {
        debugPrint('getLinkStream error: $err');
      },
    );

    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      if (value != null) {
        saveLink(value);
      }
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntentPlus.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          print(
            'Shared:${value?.map((f) => f.path).join(',') ?? ''}',
          );
        }
      },
    );
  }

  @override
  void dispose() {
    intentMediaStreamSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const BackgroundGradient(),
      Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: const HomeScreen(),
          bottomNavigationBar: Padding(
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: AddSummaryButton(),
                ),
              ],
            ),
          )),
    ]);
  }
}
