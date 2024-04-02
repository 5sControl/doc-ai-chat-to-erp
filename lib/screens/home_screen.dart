import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/screens/modal_screens/info_screen.dart';
import 'package:summify/screens/subscription_screen.dart';
import 'package:summify/screens/summary_screen.dart';

import '../bloc/settings/settings_bloc.dart';
import '../bloc/shared_links/shared_links_bloc.dart';
import '../gen/assets.gen.dart';
import '../models/models.dart';
import '../widgets/summary_tile.dart';
import 'modal_screens/how_to_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  List<SharedMediaFile>? _sharedFiles;
  String? _sharedText;

  late StreamSubscription _intentMediaStreamSubscription;
  late StreamSubscription _intentTextStreamSubscription;

  @override
  void initState() {
    super.initState();

    // For sharing images coming from outside the app while the app is in the memory
    _intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        setState(() {
          _sharedFiles = value;
          debugPrint(
            'Shared:${_sharedFiles?.map((f) => f.path).join(',') ?? ''}',
          );
        });
      },
      onError: (err) {
        debugPrint('getIntentDataStream error: $err');
      },
    );

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        setState(() {
          _sharedFiles = value;
          debugPrint(
            'Shared:${_sharedFiles?.map((f) => f.path).join(',') ?? ''}',
          );
        });
      },
    );

    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentTextStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
      (String value) {
        setState(() {
          _sharedText = value;
          debugPrint('Shared: $_sharedText');
        });
        context
            .read<SummariesBloc>()
            .add(GetSummaryFromSharedUrl(summaryUrl: value));
      },
      onError: (err) {
        debugPrint('getLinkStream error: $err');
      },
    );

    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      setState(() {
        _sharedText = value;
        debugPrint('Shared: $_sharedText');
      });
    });
  }

  @override
  void dispose() {
    _intentMediaStreamSubscription.cancel();
    _intentTextStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ReceiveSharingIntentPlus Example'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shared files:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ...?_sharedFiles?.map(
                (f) => ListTile(
                  title: Text(
                    f.type.toString().replaceFirst('SharedMediaType.', ''),
                  ),
                  subtitle: Text(f.path),
                ),
              ),
              const SizedBox(height: 100),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Shared urls/text:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              ListTile(
                title: Text(_sharedText ?? ''),
              ),
              BlocBuilder<SummariesBloc, SummariesState>(
                builder: (context, state) {
                  return Container(
                    child: Column(
                      children: state.summaries.keys
                          .toList()
                          .map((e) => Column(
                        children: [
                          Text(state.summaries[e]!.title.toString()),
                          Text(state.summaries[e]!.status.toString()),
                          Text(state.summaries[e]!.imageUrl.toString()),
                        ],
                      ))
                          .toList(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget summariesCounter(
    {required int dailySummaries, required int availableSummaries}) {
  return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(20)),
        child: Text(
          '$dailySummaries / $availableSummaries',
          style: const TextStyle(
              fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}

Widget logo() {
  return Expanded(
    flex: 2,
    child: Padding(
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
  );
}

Widget settingsButton({required Function() onPressInfo}) {
  return Expanded(
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(3),
        width: 35,
        height: 35,
        child: IconButton(
          onPressed: onPressInfo,
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            Assets.icons.settings,
            height: 35,
            width: 35,
            colorFilter:
                ColorFilter.mode(Colors.teal.shade900, BlendMode.srcIn),
          ),
        ),
      ),
    ),
  );
}
