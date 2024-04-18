import 'package:flutter/material.dart';

Widget summariesCounter(
    {required int dailySummaries, required int availableSummaries}) {
  return Expanded(
    child: Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white70, borderRadius: BorderRadius.circular(20)),
        child: Text(
          '$dailySummaries / $availableSummaries',
          style: const TextStyle(
              fontSize: 13, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    ),
  );
}