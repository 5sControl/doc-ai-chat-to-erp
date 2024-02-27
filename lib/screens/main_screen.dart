import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  static const screens = [HomeScreen(), AccountScreen()];
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

  @override
  Widget build(BuildContext context) {



    return Stack(children: [
      const BackgroundGradient(),
      Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: screens.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          // height: 100,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: const  BoxDecoration(
              color: Colors.white12,
              border: Border(top: BorderSide(color: Colors.white38))),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_filled,
                        color: Colors.white,
                      ),
                      Text('Home', style: TextStyle(color: Colors.white),)
                    ],
                  )),
              IconButton(
                  onPressed: onPressAdd,
                  icon: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_circle,
                        color: Colors.white,
                        size: 40,
                      ),
                      Text('Home', style: TextStyle(color: Colors.white),)
                    ],
                  )),
              IconButton(
                  onPressed: () {},
                  icon: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.account_circle,
                        color: Colors.white,
                      ),
                      Text('Home', style: TextStyle(color: Colors.white),)
                    ],
                  )),
            ],
          ),
        ),
      ),
    ]);
  }
}
