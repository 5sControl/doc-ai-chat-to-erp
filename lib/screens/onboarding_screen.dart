import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:summify/bloc/mixpanel/mixpanel_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

import '../gen/assets.gen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _pageViewController.dispose();
    _tabController.dispose();
  }

  void _handlePageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void onPressContinue() {
    _pageViewController.animateToPage(
      _currentPageIndex + 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    if (_currentPageIndex >= 2) {
      passOnboarding();
      context.read<MixpanelBloc>().add(OnboardingStep(step: _currentPageIndex));

      if (Platform.isIOS) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/subscribe', (Route<dynamic> route) => false);
      } else {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    }
  }

  void passOnboarding() {
    context.read<SettingsBloc>().add(const PassOnboarding());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          const BackgroundGradient(),
          Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: Padding(
              padding: EdgeInsets.only(
                  // bottom: MediaQuery.of(context).padding.bottom + 15,
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: _pageViewController,
                      onPageChanged: _handlePageViewChanged,
                      children: const [
                        // OnboardingScreen1(),
                        OnboardingScreen2(),
                        OnboardingScreen3(),
                        OnboardingScreen4(),
                      ],
                    ),
                  ),

                  // PageIndicator(
                  //   tabController: _tabController,
                  //   currentPageIndex: _currentPageIndex,
                  // ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: GestureDetector(
              onTap: onPressContinue,
              child: Container(
                height: 50,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(31, 188, 183, 1),
                    borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/onboarding/onboardingBG.png',
          fit: BoxFit.cover,
        ),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text('Welcome to Summify',
                style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    height: 1,
                    color: Colors.white),
                textAlign: TextAlign.center),
            Divider(
              color: Colors.transparent,
            ),
            Text('Personal AI Summarizer',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    color: Colors.white),
                textAlign: TextAlign.center),
          ],
        ),
      ],
    );
  }
}

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text('Goodbye information overload!',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
              textAlign: TextAlign.start),
        ),
        const Divider(
          color: Colors.transparent,
          height: 25,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset('assets/onboarding/onb1_1.png')),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Image.asset('assets/onboarding/onb1.png')),
      ],
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('One-click “share” to get summary',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w700, height: 1),
              textAlign: TextAlign.start),
        ),
        const Divider(
          color: Colors.transparent,
          height: 25,
        ),
        Container(
            margin: const EdgeInsets.only(left: 15, top: 15),
            child: Image.asset('assets/onboarding/onb2.png'))
      ],
    );
  }
}

class LangItem {
  final String title;
  final String code;
  final String? icon;
  const LangItem({required this.title, required this.icon, required this.code});
}

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    final List<LangItem> languages = [
      LangItem(title: 'English', icon: Assets.flags.en, code: 'en'),
      LangItem(title: 'Spanish', icon: Assets.flags.sp, code: 'es'),
      LangItem(title: 'French', icon: Assets.flags.fr, code: 'fr'),
      LangItem(
          title: 'Chinese (Simplified)', icon: Assets.flags.zh, code: 'zh-cn'),
      LangItem(
          title: 'Chinese (Traditional)', icon: Assets.flags.zh, code: 'zh-tw'),
      LangItem(title: 'Ukrainian', icon: Assets.flags.uk, code: 'uk'),
      LangItem(title: 'Arabic', icon: Assets.flags.ar, code: 'ar'),
      LangItem(title: 'Russian', icon: Assets.flags.ru, code: 'ru'),
      LangItem(title: 'Czech', icon: Assets.flags.cs, code: 'cs'),
      LangItem(title: 'Dutch', icon: Assets.flags.nl, code: 'nl'),
      LangItem(title: 'German', icon: Assets.flags.de, code: 'de'),
      LangItem(title: 'Greek', icon: Assets.flags.el, code: 'el'),
      LangItem(title: 'Hebrew', icon: Assets.flags.he, code: 'he'),
      LangItem(title: 'Hindi', icon: Assets.flags.hi, code: 'hi'),
      LangItem(title: 'Indonesian', icon: Assets.flags.id, code: 'id'),
      LangItem(title: 'Italian', icon: Assets.flags.it, code: 'it'),
      LangItem(title: 'Japanese', icon: Assets.flags.ja, code: 'ja'),
      LangItem(title: 'Korean', icon: Assets.flags.ko, code: 'ko'),
      LangItem(title: 'Persian', icon: Assets.flags.fa, code: 'fa'),
      LangItem(title: 'Portuguese', icon: Assets.flags.pt, code: 'pt'),
      LangItem(title: 'Romanian', icon: Assets.flags.ro, code: 'ro'),
      LangItem(title: 'Turkish', icon: Assets.flags.tr, code: 'tr'),
      LangItem(title: 'Vietnamese', icon: Assets.flags.vi, code: 'vi'),
    ];

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final selectedLang = state.translateLanguage;

        void onSelectLanguage({required String language}) {
          context
              .read<SettingsBloc>()
              .add(SetTranslateLanguage(translateLanguage: language));
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // const Spacer(),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Select your translation language',
                  style: TextStyle(
                      fontSize: 34, fontWeight: FontWeight.w700, height: 1),
                  textAlign: TextAlign.start),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 20, bottom: 100),
                shrinkWrap: true,
                children: languages
                    .map((lang) => Container(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Material(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () =>
                                  onSelectLanguage(language: lang.code),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: selectedLang == lang.code
                                          ? Theme.of(context).cardColor
                                          : Colors.transparent,
                                      width: 2),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                child: Row(
                                  children: [
                                    if (lang.icon != null)
                                      SvgPicture.asset(
                                        lang.icon!,
                                        width: 27,
                                        height: 27,
                                      ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Text(lang.title)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.tabController,
    required this.currentPageIndex,
  });

  final int currentPageIndex;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TabPageSelector(
            borderStyle: BorderStyle.none,
            controller: tabController,
            color: Colors.white,
            selectedColor: const Color.fromRGBO(31, 188, 183, 1),
          ),
        ],
      ),
    );
  }
}
