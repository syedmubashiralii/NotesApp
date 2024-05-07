import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/utils/utils.dart';

import '../controllers/signup_controller.dart';
import '../widgets/password_hint_build.dart';

class InputSecurityKeyView extends GetView<SignUpController>
    with CustomValidators {
  const InputSecurityKeyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryDarkColor,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: controller.securityFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.spaceY,
                securityKeyBuild(),
                15.spaceY,
                masterPasswordBuild(),
                30.spaceY,
                passwordRecoveryBuild(),
                30.spaceY,
                GradientButton(
                  text: "Submit",
                  onPress: () {
                    if (controller.securityFormKey.currentState!.validate()) {
                      controller.saveUserLocally();
                      // controller.moveToSecurityKeyScreen();
                    } else {
                      logSuccess("Form not valid");
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: ColorHelper.blackColor,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          // Get.put(SignUpController());
                          Get.back();
                          // pushReplacementToScreen(
                          //     context: context,
                          //     screen: const SignUpScreen());
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: ColorHelper.blackColor,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  securityKeyBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Security Key",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        5.spaceY,
        const Text(
          "Input 8 digit security key which will be used to secure notes data. Please write carefully because this key won't change once set.",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: ColorHelper.blackColor),
        ),
        15.spaceY,
        Obx(() => Column(
              children: [
                Focus(
                  onFocusChange: controller.securityKeyFieldOnFocusChanged,
                  child: MyTextField(
                    controller: controller.securityKeyFieldController,
                    validator: validateSecurityKey,
                    hintText: "8 digit key",
                    labelText: "Security Key",
                    labelSameAsHint: false,
                    fillColor: ColorHelper.primaryColor,
                    prefixIcon: Icons.lock_outline,
                    obscureText: false,
                    // Set obscureText to true for password field
                    onChanged: controller.securityKeyFieldOnChange,
                  ),
                ),
                const SizedBox(height: 15),
                ...controller.isSecurityKeyFocused.value
                    ? getPasswordCheckWidgets(controller,
                        fromSecurityScreen: true)
                    : [],
              ],
            )),
      ],
    );
  }

  masterPasswordBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Master Password",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        5.spaceY,
        const Text(
          "Provider 4 digit password which will be required to access secure documents. You can turn this off from Security & Password section.",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: ColorHelper.blackColor),
        ),
        15.spaceY,
        MyTextField(
          fillColor: ColorHelper.primaryColor,
          controller: controller.masterPasswordFieldController,
          validator: validateMasterPassword,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
            // Limits input to 4 characters
          ],
          hintText: "4 digit password",
          labelText: "Master Password",
          prefixIcon: Icons.person,
          labelSameAsHint: false,
        ),
      ],
    );
  }

  passwordRecoveryBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Password recovery",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
        ),
        5.spaceY,
        const Text(
          "Provide your answer for recovery of master password. This question will be asked when you will try to recover master password",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: ColorHelper.blackColor),
        ),
        15.spaceY,
        const Text("Select question: "),
        Obx(
          () {
            return Wrap(
              children: [
                for (int i = 0;
                    i < controller.recoveryQuestionsList.length;
                    i++)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio<int>(
                        fillColor: MaterialStateProperty.all<Color>(ColorHelper.primaryColor),
                        focusColor: ColorHelper.primaryDarkColor,
                        value: i,
                        groupValue: controller.selectedRecoveryQuestion.value,
                        onChanged: (value) {
                          controller.selectedRecoveryQuestion.value = value!;
                        },
                      ),
                      Text(controller.recoveryQuestionsList[i]),
                    ],
                  ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Radio<int>(
                //       value: 1,
                //       groupValue: controller.selectedRecoveryQuestion.value,
                //       onChanged: (value) {
                //         controller.selectedRecoveryQuestion.value = value!;
                //       },
                //     ),
                //     const Text('In which city you were born?'),
                //   ],
                // ),
                // Row(
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Radio<int>(
                //       value: 2,
                //       groupValue: controller.selectedRecoveryQuestion.value,
                //       onChanged: (value) {
                //         controller.selectedRecoveryQuestion.value = value!;
                //       },
                //     ),
                //     const Text('What is your favourite color?'),
                //   ],
                // )
              ],
            );
          },
        ),
        15.spaceY,
        MyTextField(
          controller: controller.recoveryQuestionAnswerFieldController,
          validator: validateSecurityQuestionAnswer,
          hintText: "Answer",
          prefixIcon: Icons.person,fillColor: ColorHelper.primaryColor,
        ),
      ],
    );
  }
}
