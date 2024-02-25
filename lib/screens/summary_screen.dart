import 'package:flutter/material.dart';

import '../models/models.dart';

class SummaryScreen extends StatelessWidget {
  final Summary summaryData;
  const SummaryScreen({super.key, required this.summaryData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Summary',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Summary",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Text(summaryData.summary),
              Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Additional Context",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Text(summaryData.additionalContext),
              Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Implications Conclusions",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Text(summaryData.implicationsConclusions),
              Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "In Depth Analysis",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Text(summaryData.inDepthAnalysis),
              Divider(),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Key Points",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: summaryData.keyPoints.map((e) => Text(e)).toList(),
              ),
              Divider(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Supporting Evidence",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: summaryData.supportingEvidence.map((e) => Text(e)).toList(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
