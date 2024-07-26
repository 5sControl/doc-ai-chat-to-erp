import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showErrorToast({required BuildContext context, required String error}) {
  toastification.show(
    context: context,
    icon: Container(),
    alignment: Alignment.topCenter,
    style: ToastificationStyle.simple,
    backgroundColor: Colors.red.shade500,
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
        error,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall!,
      ),
    ),
    autoCloseDuration: const Duration(seconds: 5),
  );
}