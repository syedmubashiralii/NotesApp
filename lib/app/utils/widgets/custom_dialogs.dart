import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogs {
  static showLoadingDialog({String? message}) {
    // BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
    // );
    Get.defaultDialog(
      title: "",
      // backgroundColor: Colors.white.withOpacity(0.8),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50.0,
            width: 50.0,
            child: CustomActivityIndicator(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            message ?? 'Loading',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  static showMessageDialog(
      {required String title,
      String? description,
      void Function()? onConfirm}) {
    // BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 18.0, sigmaY: 18.0),
    // );
    Get.defaultDialog(
      title: title,

      onConfirm: onConfirm ??
          () {
            Get.back();
          },
      // backgroundColor: Colors.white.withOpacity(0.8),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10.0),
          // Text(
          //   title!,
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.grey.shade700,
          //     fontSize: 15.0,
          //     fontWeight: FontWeight.bold,
          //     decoration: TextDecoration.none,
          //   ),
          // ),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13.0,
              // fontWeight: FontWeight.bold,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  static closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

class CustomActivityIndicator extends CupertinoActivityIndicator {
  @override
  final Color? color;

  const CustomActivityIndicator(
      {super.key, double size = 40.0, this.color = Colors.grey})
      : super(
          radius: size / 2.0,
          animating: true,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2.0,
      height: radius * 2.0,
      child: CustomPaint(
        painter: _CustomActivityIndicatorPainter(color: color),
      ),
    );
  }
}

class _CustomActivityIndicatorPainter extends CustomPainter {
  static const kLineWidth = 5.0;
  static const kLineGap = 2.0;
  static const kLineCount = 12;

  Color? color;

  _CustomActivityIndicatorPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.grey
      ..strokeWidth = kLineWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const anglePerLine = 2 * pi / kLineCount;
    final radius = size.width / 2 - kLineWidth / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < kLineCount; i++) {
      final angle = anglePerLine * i;
      final start = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      final end = Offset(
        center.dx + (radius - kLineGap) * cos(angle),
        center.dy + (radius - kLineGap) * sin(angle),
      );
      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
