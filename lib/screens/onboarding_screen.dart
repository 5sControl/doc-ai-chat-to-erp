import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:summify/bloc/settings/settings_bloc.dart';
import 'package:summify/widgets/backgroung_gradient.dart';

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
    if (_currentPageIndex >= 3) {
      passOnboarding();
      // Navigator.of(context).pushNamed('/');
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/subscribe', (Route<dynamic> route) => false);
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
            body: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom,
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
                        OnboardingScreen1(),
                        OnboardingScreen2(),
                        OnboardingScreen4(),
                        OnboardingScreen3(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onPressContinue,
                    child: Container(
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
                  // PageIndicator(
                  //   tabController: _tabController,
                  //   currentPageIndex: _currentPageIndex,
                  // ),
                ],
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
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Click "Share" and get a summary',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w700, height: 1),
              textAlign: TextAlign.start),
        ),
        const Divider(
          color: Colors.transparent,
          height: 25,
        ),
        Image.asset('assets/onboarding/onboardingImg1.png')
      ],
    );
  }
}

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Easily summarize anything',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w700, height: 1),
              textAlign: TextAlign.start),
        ),
        const Divider(
          color: Colors.transparent,
          height: 25,
        ),
        Image.asset('assets/onboarding/onboardingImg2.png')
      ],
    );
  }
}

class OnboardingScreen4 extends StatelessWidget {
  const OnboardingScreen4({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Enjoy on every browser and app',
              style: TextStyle(
                  fontSize: 36, fontWeight: FontWeight.w700, height: 1),
              textAlign: TextAlign.start),
        ),
        const Divider(
          color: Colors.transparent,
          height: 25,
        ),
        Image.asset('assets/onboarding/onboardingImg3.png')
      ],
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
