import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/auth/controllers/auth_controller.dart';
import 'package:notes_final_version/app/modules/auth/views/signup_view.dart';

import '../../../utils/utils.dart';
import '../controllers/signup_controller.dart';
import '../widgets/password_hint_build.dart';

class Login extends StatelessWidget with CustomValidators {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: controller.loginFormKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.spaceY,
              const Text(
                "Welcome Back 👋",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
              ),
              5.spaceY,
              const Text(
                "Let's log in.",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: ColorHelper.blackColor),
              ),
              30.spaceY,
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

              30.spaceY,
              // isLoading
              //     ? circularProgress()
              //     :
              GradientButton(
                text: "Log In",
                onPress: () {
                  if (controller.loginFormKey.currentState!.validate()) {
                    // checkAndInsertUser(emailController.text.trim(),
                    //     passwordController.text.trim());
                    DefaultSnackbar.show(
                        "Error", "User not exist. Try registering yourself.");
                  } else {
                    logSuccess("Form not valid");
                  }
                },
              ),
              20.spaceY,
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: TextButton(
              //       onPressed: () {},
              //       child: const Text(
              //         "Forget Password?",
              //         style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           fontSize: 15,
              //           color: ColorHelper.blackColor,
              //         ),
              //       )),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                      color: ColorHelper.blackColor,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.put(SignUpController());

                        Get.to(() => const SignUpView());
                      },
                      child: const Text(
                        "Register",
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
    );
  }
}
