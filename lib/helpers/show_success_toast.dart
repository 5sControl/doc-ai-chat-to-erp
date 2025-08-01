import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showSuccessToast({required BuildContext context, required String title}) {
  toastification.show(
    context: context,
    icon: Container(),
    alignment: Alignment.topCenter,
    style: ToastificationStyle.simple,
    backgroundColor: Colors.green.shade500,
    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    applyBlurEffect: true,
    showProgressBar: false,
    closeButtonShowType: CloseButtonShowType.none,
    type: ToastificationType.success,
    padding: const EdgeInsets.symmetric(vertical: 10),
    animationDuration: const Duration(milliseconds: 200),
    title: SizedBox(
      width: double.infinity,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall!,
      ),
    ),
    autoCloseDuration: const Duration(seconds: 5),
  );
}