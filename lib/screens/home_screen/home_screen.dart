import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/bloc/subscriptions/subscriptions_bloc.dart';
import 'package:summify/bloc/summaries/summaries_bloc.dart';
import 'package:summify/gen/assets.gen.dart';
import 'package:summify/l10n/app_localizations.dart';
import 'package:summify/models/models.dart';
import 'package:summify/screens/home_screen/settings_button.dart';
import 'package:summify/screens/home_screen/bookmarks_button.dart';
import 'package:summify/screens/home_screen/premium_banner.dart';
import 'package:summify/screens/subscribtions_screen/subscriptions_screen_limit.dart';
import 'package:summify/screens/summary_screen/info_modal/extension_modal.dart';
import 'package:summify/services/demo_data_initializer.dart';
import 'package:summify/widgets/ads_carousel.dart';

import 'logo.dart';
import 'summary_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  List<SummaryData> _allSummaries = [];
  List<SummaryData> _filteredSummaries = [];

  void getSummary({required String summaryUrl}) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (SummariesBloc.isFreeDailyLimitReached(
        context.read<SummariesBloc>().state,
        context.read<SubscriptionsBloc>().state.subscriptionStatus,
      )) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SubscriptionScreenLimit(
              triggerScreen: 'Summary',
              fromSettings: true,
            ),
          ),
        );
        return;
      }
      context
          .read<SummariesBloc>()
          .add(GetSummaryFromUrl(summaryUrl: summaryUrl, fromShare: true));
    });
  }

  void getSummaryFromFile(
      {required String filePath, required String fileName}) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      if (SummariesBloc.isFreeDailyLimitReached(
        context.read<SummariesBloc>().state,
        context.read<SubscriptionsBloc>().state.subscriptionStatus,
      )) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SubscriptionScreenLimit(
              triggerScreen: 'Summary',
              fromSettings: true,
            ),
          ),
        );
        return;
      }
      context.read<SummariesBloc>().add(GetSummaryFromFile(
          filePath: filePath, fileName: fileName, fromShare: true));
      context.read<MixpanelBloc>().add(Summify(option: 'file'));
    });
  }

  @override
  void initState() {
    _allSummaries =
        context.read<SummariesBloc>().state.summaries.values.toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    _filteredSummaries = _allSummaries;

    _searchController.addListener(() {
      _filterSummaries(_searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterSummaries(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredSummaries = _allSummaries;
        return;
      }

      String lowerQuery = query.trim().toLowerCase();
      _filteredSummaries = _allSummaries.where((summaryData) {
        return summaryData.summaryPreview.title
                ?.toLowerCase()
                .contains(lowerQuery) ??
            false;
      }).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void onPressSettings() {
    Navigator.of(context).pushNamed('/settings');
  }

  void onPressBookmarks() {
    Navigator.of(context).pushNamed('/saved-cards');
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
              _allSummaries = summariesState.summaries.values.toList()
                ..sort((a, b) => b.date.compareTo(a.date));
              _filteredSummaries = _searchController.text.isEmpty
                  ? _allSummaries
                  : _filteredSummaries;

              return BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
                builder: (context, state) {
                  final isSubscribed =
                      state.subscriptionStatus == SubscriptionStatus.subscribed;
                  return DefaultTabController(
                    initialIndex: 0,
                    length: 1,
                    child: GestureDetector(
                      onTap: () {
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
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          fillColor:
                              const Color.fromRGBO(187, 247, 247, 1),
                          hintText: AppLocalizations.of(context).home_search,
                          prefixIcon: const Icon(
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
                                                    setState(() {});
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
                                ],
                              ),
                            ),
                            title: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: onPressDesktop,
                                  padding: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.15),
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
                                ),
                                const Logo(),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BookmarksButton(
                                          onPressBookmarks: onPressBookmarks),
                                      const SizedBox(width: 8),
                                      SettingsButton(
                                          onPressSettings: onPressSettings),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        body: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Builder(
                                builder: (context) {
                                  final demoKey =
                                      DemoDataInitializer.demoKey;
                                  final filteredEntries =
                                      summariesState.summaries.entries
                                          .where((e) =>
                                              _filteredSummaries.contains(e.value))
                                          .toList();
                                  final demoEntry = filteredEntries
                                      .where((e) => e.key == demoKey)
                                      .firstOrNull;
                                  final userEntries = filteredEntries
                                      .where((e) => e.key != demoKey)
                                      .toList()
                                    ..sort((a, b) =>
                                        b.value.date.compareTo(a.value.date));
                                  final orderedKeys = <String>[
                                    if (demoEntry != null) demoEntry.key,
                                    ...userEntries.map((e) => e.key),
                                  ];
                                  final carouselIndex =
                                      demoEntry != null ? 1 : 0;
                                  final itemCount =
                                      orderedKeys.length + 1;
                                  return ListView.builder(
                                    itemCount: itemCount,
                                    itemBuilder: (context, index) {
                                      if (index == carouselIndex) {
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8),
                                          child: AdsCarousel(),
                                        );
                                      }
                                      final summaryIndex = index <
                                              carouselIndex
                                          ? index
                                          : index - 1;
                                      final link =
                                          orderedKeys[summaryIndex];
                                      return SummaryTile(
                                        sharedLink: link,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
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
