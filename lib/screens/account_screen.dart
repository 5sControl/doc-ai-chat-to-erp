import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.teal.shade500,
      ),
      body: Center(
        child: Text('Account'),
      ),
    );
  }
}
