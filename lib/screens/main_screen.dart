import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:summify/bloc/shared_links/shared_links_bloc.dart';
import 'package:summify/screens/account_screen.dart';
import 'package:summify/screens/add_screen.dart';
import 'package:summify/screens/auth/auth_screen.dart';
import 'package:summify/screens/home_screen.dart';

import '../widgets/backgroung_gradient.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late StreamSubscription _intentSub;
  static final screens = [HomeScreen(), AccountScreen()];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void saveLink(SharedMediaFile sharedItem) {
    context
        .read<SharedLinksBloc>()
        .add(SaveSharedLink(sharedLink: sharedItem.path));
  }

  @override
  void initState() {
    super.initState();
    _intentSub = ReceiveSharingIntent.getMediaStream().listen((value) {
      // print(value);
      setState(() {
        _selectedIndex = 0;
      });
      for (var sharedItem in value) {
        saveLink(sharedItem);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      setState(() {
        _selectedIndex = 0;
      });
      for (var sharedItem in value) {
        saveLink(sharedItem);
      }
      ReceiveSharingIntent.reset();
    });
  }

  @override
  void dispose() {
    _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      const BackgroundGradient(),
      Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: screens.elementAt(_selectedIndex),
        bottomNavigationBar: CustomBottomNavBar(
            onTap: _onItemTapped, selectedIndex: _selectedIndex),
      ),
    ]);
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int index) onTap;
  const CustomBottomNavBar(
      {super.key, required this.onTap, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 400);

    void onPressAdd() {
      showCupertinoModalBottomSheet(
        context: context,
        expand: false,
        bounce: false,
        barrierColor: Colors.black12,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const AddScreen();
        },
      );
    }

    return ClipPath(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.7),
              border: const Border(top: BorderSide(color: Colors.white38))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedScale(
                  duration: duration,
                  scale: selectedIndex == 0 ? 1.2 : 1,
                  child: IconButton(
                      onPressed: () => onTap(0),
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedCrossFade(
                              firstChild: SvgPicture.asset(
                                'assets/icons/home_filled.svg',
                                width: 26,
                                height: 26,
                              ),
                              secondChild: SvgPicture.asset(
                                'assets/icons/home.svg',
                                width: 26,
                                height: 26,
                              ),
                              crossFadeState: selectedIndex == 0
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: duration),
                          const Text(
                            'Home',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      )),
                ),
              ),
              Expanded(
                child: IconButton(
                    onPressed: onPressAdd,
                    icon: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 40,
                        ),
                        Text(
                          'Add',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    )),
              ),
              Expanded(
                child: AnimatedScale(
                  duration: duration,
                  scale: selectedIndex == 1 ? 1.1 : 1,
                  child: IconButton(
                      onPressed: () => onTap(1),
                      icon: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedCrossFade(
                              firstChild: SvgPicture.asset(
                                'assets/icons/profile_filled.svg',
                                width: 26,
                                height: 26,
                              ),
                              secondChild: SvgPicture.asset(
                                'assets/icons/profile.svg',
                                width: 26,
                                height: 26,
                              ),
                              crossFadeState: selectedIndex == 1
                                  ? CrossFadeState.showFirst
                                  : CrossFadeState.showSecond,
                              duration: duration),
                          const Text(
                            'Account',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
