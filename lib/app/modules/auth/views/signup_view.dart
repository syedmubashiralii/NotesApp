import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/auth/controllers/signup_controller.dart';

import '../widgets/password_hint_build.dart';
import '/app/utils/utils.dart';

class SignUpView extends GetView<SignUpController> with CustomValidators {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: controller.signupFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                60.spaceY,
                const Text(
                  "Welcome to Kp Notes 👋",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                ),
                5.spaceY,
                const Text(
                  "Provide following details to create your account!",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: ColorHelper.grey),
                ),
                30.spaceY,
                MyTextField(
                  controller: controller.usernameFieldController,
                  validator: validateUsername,
                  hintText: "Username",
                  prefixIcon: Icons.person,
                ),
                15.spaceY,
                MyTextField(
                  controller: controller.emailFieldController,
                  validator: validateEmail,
                  hintText: "Email",
                  prefixIcon: Icons.email_outlined,
                ),
                15.spaceY,

                Obx(() => Column(
                      children: [
                        Focus(
                          onFocusChange: controller.passwordFieldOnFocusChanged,
                          child: MyTextField(
                            controller: controller.passwordFieldController,
                            validator: validatePassword,
                            hintText: "Password",
                            prefixIcon: Icons.lock_outline,
                            obscureText: true,
                            // Set obscureText to true for password field
                            onChanged: controller.passwordFieldOnChange,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ...controller.isPasswordFocused.value
                            ? getPasswordCheckWidgets(controller)
                            : [],
                      ],
                    )),
                15.spaceY,
                MyTextField(
                  controller: controller.passwordHintFieldController,
                  validator: validatePasswordHint,
                  maxLines: 3,
                  hintText: "Password hint",
                  prefixIcon: Icons.password,
                ),

                30.spaceY,
                // isLoading
                //     ? circularProgress()
                //     :
                GradientButton(
                  text: "Signup",
                  onPress: () {
                    if (controller.signupFormKey.currentState!.validate()) {
                      // controller.createUser();
                      controller.moveToSecurityKeyScreen();
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
                        color: ColorHelper.grey,
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
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
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
}
