import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:summishare/bloc/shared_links/shared_links_bloc.dart';
import 'package:summishare/screens/account_screen.dart';
import 'package:summishare/screens/auth/auth_sreen.dart';
import 'package:summishare/screens/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late StreamSubscription _intentSub;

  static const screens = [HomeScreen(), AuthScreen()];

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
      for (var sharedItem in value) {
        saveLink(sharedItem);
      }
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // Get the media sharing coming from outside the app while the app is closed.
    ReceiveSharingIntent.getInitialMedia().then((value) {
      // value.forEach((shareItem) => print(shareItem.path));
      print('!!!!>>>>>');
      // setState(() {
      //   _sharedFiles.clear();
      //   _sharedFiles.addAll(value);
      //   ReceiveSharingIntent.reset();
      // });
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
    return Scaffold(
        body: screens.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: 10,
          backgroundColor: Colors.teal.shade500,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
              ),
              label: 'Account',
            ),
          ],
          selectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}
