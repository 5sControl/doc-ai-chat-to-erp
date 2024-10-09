import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent_plus/receive_sharing_intent_plus.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/home_screen/settings_button.dart';
import 'package:summify/screens/home_screen/premium_banner.dart';
import 'package:summify/screens/summary_screen/info_modal/extension_modal.dart';

import 'logo.dart';
import 'summary_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late StreamSubscription _intentMediaStreamSubscription;
  late StreamSubscription _intentTextStreamSubscription;

  final TextEditingController _searchController = TextEditingController();
  List<SummaryData> _allSummaries = [];
  List<SummaryData> _filteredSummaries = [];

  void getSummary({required String summaryUrl}) {
    Future.delayed(const Duration(milliseconds: 300), () {
      // if (daySummaries >= limit) {
      //   showCupertinoModalBottomSheet(
      //     context: context,
      //     expand: false,
      //     bounce: false,
      //     barrierColor: Colors.black54,
      //     backgroundColor: Colors.transparent,
      //     builder: (context) {
      //       return const SubscriptionScreen(fromOnboarding: true,);
      //     },
      //   );
      //   context
      //       .read<MixpanelBloc>()
      //       .add(LimitReached(resource: summaryUrl, registrated: false));
      // } else {
      context
          .read<SummariesBloc>()
          .add(GetSummaryFromUrl(summaryUrl: summaryUrl, fromShare: true));
      // }
    });
  }

  void getSummaryFromFile(
      {required String filePath, required String fileName}) {
    // final DateFormat formatter = DateFormat('MM.dd.yy');
    // final thisDay = formatter.format(DateTime.now());
    // final limit = context.read<SummariesBloc>().state.dailyLimit;
    // final daySummaries =
    //     context.read<SummariesBloc>().state.dailySummariesMap[thisDay] ?? 0;

    Future.delayed(const Duration(milliseconds: 300), () {
      context.read<SummariesBloc>().add(GetSummaryFromFile(
          filePath: filePath, fileName: fileName, fromShare: true));
      context.read<MixpanelBloc>().add(Summify(option: 'file'));
      // }
    });
  }

  @override
  void initState() {
    // _allSummaries = context
    //     .read<SummariesBloc>()
    //     .state
    //     .summaries
    //     .keys
    //     .toList()
    //     .reversed
    //     .toList();
    // _filteredSummaries = _allSummaries;
    // print(_allSummaries);
    // For sharing images coming from outside the app while the app is in the memory
    _intentMediaStreamSubscription =
        ReceiveSharingIntentPlus.getMediaStream().listen(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          final fileName = value.first.path.split('/').last.toString();
          final filePath = value.first.path.replaceFirst('file://', '');
          getSummaryFromFile(filePath: filePath, fileName: fileName);
        }
      },
      onError: (err) {
        debugPrint('getIntentDataStream error: $err');
      },
    );
    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialMedia().then(
      (List<SharedMediaFile> value) {
        if (value.isNotEmpty) {
          final fileName = value.first.path.split('/').last.toString();
          final filePath = value.first.path.replaceFirst('file://', '');
          Future.delayed(const Duration(seconds: 1), () {
            getSummaryFromFile(filePath: filePath, fileName: fileName);
          });
        }
      },
    );
    // For sharing or opening urls/text coming from outside the app while the app is in the memory
    _intentTextStreamSubscription =
        ReceiveSharingIntentPlus.getTextStream().listen(
      (String value) {
        getSummary(summaryUrl: value);
      },
      onError: (err) {
        debugPrint('getLinkStream error: $err');
      },
    );
    // For sharing or opening urls/text coming from outside the app while the app is closed
    ReceiveSharingIntentPlus.getInitialText().then((String? value) {
      if (value != null) {
        Future.delayed(const Duration(seconds: 1), () {
          getSummary(summaryUrl: value);
        });
      }
    });

    if (context.read<SettingsBloc>().state.howToShowed == false) {
      // Future.delayed(const Duration(milliseconds: 2000), () {
      //   showCupertinoModalBottomSheet(
      //     context: context,
      //     expand: false,
      //     bounce: false,
      //     barrierColor: Colors.black54,
      //     backgroundColor: Colors.transparent,
      //     builder: (context) {
      //       return const SetUpShareScreen();
      //     },
      //   );
      //   context.read<SettingsBloc>().add(const HowToShowed());
      // });
    }
    _allSummaries =
        context.read<SummariesBloc>().state.summaries.values.toList();
    _filteredSummaries = _allSummaries;

    _searchController.addListener(() {
      _filterSummaries(_searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _intentMediaStreamSubscription.cancel();
    _intentTextStreamSubscription.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _filterSummaries(String query) {
    setState(() {
      // If the query is empty, reset the filtered list to all summaries
      if (query.trim().isEmpty) {
        _filteredSummaries = _allSummaries;
        return;
      }

      // Convert query to lowercase for case-insensitive matching
      String lowerQuery = query.trim().toLowerCase();

      // Filter summaries where the title contains the query
      _filteredSummaries = _allSummaries.where((summaryData) {
        print(summaryData.summaryPreview.title);
        return summaryData.summaryPreview.title
                ?.toLowerCase()
                .contains(lowerQuery) ??
            false;
      }).toList();
    });
  }

  // MATCHES AT THE START OF THE TITLE
  // void _filterSummaries(String query) {
  //   setState(() {
  //     // If the query is empty, reset the filtered list to all summaries
  //     if (query.trim().isEmpty) {
  //       _filteredSummaries = _allSummaries;
  //       return;
  //     }

  //     // Convert query to lowercase for case-insensitive matching
  //     String lowerQuery = query.trim().toLowerCase();

  //     // Filter summaries where the title starts with the query
  //     _filteredSummaries = _allSummaries.where((title) {
  //       // Convert title to lowercase
  //       return title.toLowerCase().startsWith(lowerQuery);
  //     }).toList();
  //   });
  // }

  void onPressSettings() {
    Navigator.of(context).pushNamed('/settings');
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, settingsState) {
          return BlocBuilder<SummariesBloc, SummariesState>(
            builder: (context, summariesState) {
              //final sumsKeys = summariesState.summaries.keys.toList();
              _allSummaries = summariesState.summaries.values.toList();
              _filteredSummaries = _searchController.text.isEmpty
                  ? _allSummaries
                  : _filteredSummaries;
              // _allSummaries = [];
              // _titleToLinkMap = {};
              // summariesState.summaries.forEach((link, summaryData) {
              //   final title = summaryData.summaryPreview.title ?? '';
              //   _allSummaries.add(title);
              //   _titleToLinkMap[title] = link;
              // });

              // Initialize _filteredSummaries if needed
              // if (_filteredSummaries.isEmpty ||
              //     _searchController.text.isEmpty) {
              //   _filteredSummaries = _allSummaries;
              // }
              // final DateFormat dayFormatter = DateFormat('MM.dd.yy');
              // final thisDay = dayFormatter.format(DateTime.now());
              //final summaries =
              //    summariesState.summaries.keys.toList().reversed.toList();
              return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                //buildWhen: (previous, current) =>
                //   previous.subscriptionStatus != current.subscriptionStatus,
                builder: (context, state) {
                  final isSubscribed =
                      state.subscriptionStatus == SubscriptionStatus.subscribed;
                  return DefaultTabController(
                    initialIndex: 0,
                    length: 1,
                    child: GestureDetector(
                      onTap: () {
                        // Dismiss the keyboard when tapped outside
                        FocusScope.of(context).unfocus();
                      },
                      child: Scaffold(
                        extendBodyBehindAppBar: true,
                        appBar: AppBar(
                            flexibleSpace: ClipRRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 8,
                                    sigmaY: 8,
                                    tileMode: TileMode.mirror),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                            automaticallyImplyLeading: false,
                            elevation: 0,
                            bottom: PreferredSize(
                              preferredSize: Size(
                                  MediaQuery.of(context).size.width,
                                  !isSubscribed ? 140.0 : 70),
                              child: Column(
                                children: [
                                  !isSubscribed
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: state
                                                  is SubscriptionsStateLoading
                                              ? const CircularProgressIndicator()
                                              : const PremiumBanner(),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            8), // Rounded corners
                                      ),
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          fillColor:
                                              Color.fromRGBO(187, 247, 247, 1),
                                          hintText: 'Search',
                                          prefixIcon: Icon(
                                            Icons.search,
                                            size: 20,
                                          ),
                                          suffixIcon: _searchController
                                                  .text.isEmpty
                                              ? null
                                              : IconButton(
                                                  icon: Icon(Icons.clear, size: 20,),
                                                  onPressed: () {
                                                    _searchController.clear();
                                                    setState(
                                                        () {}); // Update the UI
                                                  },
                                                ),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 8),
                                        ),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  //const HomeTabs(),
                                ],
                              ),
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // SummariesCounter(
                                //     availableSummaries: 2,
                                //     dailySummaries:
                                //         summariesState.freeSummaries >= 2
                                //             ? 2
                                //             : summariesState.freeSummaries),
                                IconButton(
                                  onPressed: onPressDesktop,
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.2),
                                  visualDensity: VisualDensity.compact,
                                  icon: SvgPicture.asset(
                                    Assets.icons.desctop,
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                        BlendMode.srcIn),
                                  ),
                                  //color: Colors.white,
                                ),
                                const Logo(),
                                SettingsButton(
                                    onPressSettings: onPressSettings),
                              ],
                            )),
                        body: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ListView.builder(
                                itemCount: _filteredSummaries.length,

                                itemBuilder: (context, index) {
                                  // final title = _filteredSummaries[index];
                                  //final link = _filteredSummaries[index];
                                  final summaryData = _filteredSummaries[index];
                                  final link = summariesState.summaries.entries
                                      .firstWhere(
                                          (entry) => entry.value == summaryData)
                                      .key;
                                  // Pass the link to SummaryTileah
                                  return SummaryTile(
                                    sharedLink: link,
                                  );
                                },
                                // itemCount: _filteredSummaries
                                //     .length, // Use the filtered list
                                // itemBuilder: (context, index) {
                                //   return SummaryTile(
                                //     sharedLink: _filteredSummaries[
                                //         index], // Use the filtered list
                                //   );
                                // },
                              ),
                            ),
                            // BlocBuilder<LibraryBloc, LibraryState>(
                            //   builder: (context, libraryState) {
                            //     final List<String> items =
                            //         libraryState.libraryDocuments.keys.toList();
                            //         return Container();
                            //     // return Container(
                            //     //   padding: const EdgeInsets.only(top: 10),
                            //     //   child: ListView.builder(
                            //     //     itemCount: items.length,
                            //     //     itemBuilder: (context, index) {
                            //     //       return LibraryDocumentTile(
                            //     //         libraryDocument: libraryState
                            //     //             .libraryDocuments[items[index]]!,
                            //     //       );
                            //     //       return Container();
                            //     //     },
                            //     //   ),
                            //     // );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// class LibraryDocumentTile extends StatelessWidget {
//   final LibraryDocument libraryDocument;

//   const LibraryDocumentTile({super.key, required this.libraryDocument});

//   @override
//   Widget build(BuildContext context) {
//     void onPressDocument() {
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) {
//           return LibraryDocumentScreen(libraryDocument: libraryDocument);
//         },
//       ));
//     }

//     return ListTile(
//       leading: null,
//       trailing: null,
//       minVerticalPadding: 0,
//       minLeadingWidth: 0,
//       horizontalTitleGap: 0,
//       contentPadding:
//           const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
//       title: SizedBox(
//         height: 80,
//         child: AspectRatio(
//           aspectRatio: 3.5,
//           child: Material(
//             borderRadius: BorderRadius.circular(10),
//             color: Theme.of(context).primaryColor.withOpacity(0.2),
//             child: InkWell(
//               splashFactory: InkSplash.splashFactory,
//               highlightColor: Theme.of(context).canvasColor.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(10),
//               onTap: onPressDocument,
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   AspectRatio(
//                       aspectRatio: 1,
//                       child: Container(
//                           clipBehavior: Clip.hardEdge,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 2, vertical: 2),
//                           child: Hero(
//                             tag: libraryDocument.title,
//                             child: Image.asset(
//                               libraryDocument.img,
//                               fit: BoxFit.cover,
//                             ),
//                           ))),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 7, vertical: 0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisSize: MainAxisSize.max,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             libraryDocument.title,
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .displayMedium!
//                                 .copyWith(fontWeight: FontWeight.w400),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
