import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';

class DefaultSnackbar {
  static void show(String title, String message,
      {Duration duration = const Duration(seconds: 6)}) {
    if (Get.isSnackbarOpen) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        // Your Get Snackbar
        Get.closeCurrentSnackbar();
      });
    }

    Get.snackbar(
      title,
      message,
      duration: duration,
      backgroundColor: ColorHelper.primaryColor,
      snackPosition: SnackPosition.TOP,
      colorText: Colors.black,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
      reverseAnimationCurve: Curves.easeInBack,
      animationDuration: const Duration(milliseconds: 500),
      icon: const Icon(
        Icons.info_outline,
        color: Colors.black,
      ),
      shouldIconPulse: true,
    );
  }
}
