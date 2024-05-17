import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';

void showSystemDialog({required BuildContext context, required String title}) {
  showPlatformDialog(
    context: context,
    builder: (context) => BasicDialogAlert(
      title: Text(title),
      actions: <Widget>[
        BasicDialogAction(
          title: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
