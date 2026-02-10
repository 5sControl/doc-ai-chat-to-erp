import 'package:flutter/material.dart';

/// Placeholder shown when knowledge cards could not be loaded (e.g. server error).
class UnsupportedDevicePlaceholder extends StatelessWidget {
  const UnsupportedDevicePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 186, 195, 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.cloud_off_outlined,
                size: 40,
                color: Color.fromRGBO(0, 186, 195, 1),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Knowledge Cards',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Couldn’t load cards. Check your connection and try again.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black54,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
