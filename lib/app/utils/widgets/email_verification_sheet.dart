import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/utils.dart';
import 'package:pinput/pinput.dart';

class EmailVerificationSheet extends StatelessWidget {
  EmailVerificationSheet({
    super.key,
    required this.phoneNumber,
    this.countdownDuration,
    this.onTapResendCode,
    this.digits = 4,
    this.title,
    this.subtitle,
  });

  String phoneNumber;
  Duration? countdownDuration;
  VoidCallback? onTapResendCode;
  String? title;
  String? subtitle;
  int digits;
  Timer? _timer;

  Future<String?> show() async {
    String? val = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: Get.context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(),
      builder: (BuildContext context) {
        return this;
      },
    );
    return val;
  }

  final defaultPinTheme = PinTheme(
    width: 60,
    height: 76,
    textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      border: Border.all(color: Colors.grey),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.25),
        ),
        BoxShadow(
          color: Color(0xfff1f1f1),
          spreadRadius: -1.0,
          blurRadius: 3.0,
          offset: Offset(3, 3),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    RxInt secondsLeft = countdownDuration?.inSeconds.obs ?? 0.obs;
    if (countdownDuration != null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (t) {
        if (secondsLeft > 0) {
          secondsLeft.value = secondsLeft.value - 1;
        }
      });
    }
    return SizedBox(
      height: Get.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            alignment: Alignment.topLeft,
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
              height: Get.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 5,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey,
                    ),
                  ),
                  Row(
                    children: [

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            50.spaceY,
                            Row(
                              children: [
                                Text(
                                  title ?? "2 Factor Authorization".tr,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                            5.spaceY,
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    subtitle ??
                                        "Please enter the OTP, we sent on".tr+" " +phoneNumber + "to verify your confirmation.".tr,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: ColorHelper.grey),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  60.spaceY,
                  Pinput(
                    defaultPinTheme: defaultPinTheme,
                    length: digits,
                    focusedPinTheme: defaultPinTheme.copyDecorationWith(
                      border: Border.all(
                          color: const Color.fromRGBO(114, 178, 238, 1)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: const Color.fromRGBO(234, 239, 243, 1),
                      ),
                    ),
                    validator: (s) {
                      return '';
                    },
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      Get.back(result: pin);
                    },
                  ),
                  25.spaceY,
                  if (onTapResendCode != null)
                    Obx(() {
                      return RichText(
                          text: TextSpan(
                              text: "Resend OTP in ",
                              style: TextStyle(
                                  color: ColorHelper.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal),
                              children: [
                            TextSpan(
                                text: "${secondsLeft.value}",
                                style: TextStyle(
                                    color: ColorHelper.primaryDarkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400)),
                          ]));
                    }),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: GradientButton(
                      text: "Cancel",
                      onPress: () {
                        Get.back();
                      },
                    ),
                  ),
                  60.spaceY,
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
