import 'package:flutter/material.dart';

import '../models/models.dart';

class SummaryScreen extends StatelessWidget {
  final Summary summaryData;
  const SummaryScreen({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text(
          'Summary',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor: Colors.teal.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                "Summary",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
            Text(summaryData.summary),
            // Text()
          ],
        ),
      ),
    );
  }
}
