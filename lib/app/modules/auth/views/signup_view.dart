import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:notes_final_version/app/modules/auth/controllers/signup_controller.dart';

import '../widgets/password_hint_build.dart';
import '/app/utils/utils.dart';

class SignUpView extends GetView<SignUpController> with CustomValidators {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryDarkColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: controller.signupFormKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.spaceY,

                  InkWell(
                    onTap:(){Get.back();},
                    child: CircleAvatar(backgroundColor: ColorHelper.primaryColor,child: Center(child: Icon(Icons.arrow_back),),)),
                   10.spaceY,
                  const Text(
                    "SignUp",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 25),
                  ),
                  5.spaceY,
                  const Text(
                    "Provide following details to create your account!",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: ColorHelper.blackColor),
                  ),
                  30.spaceY,
                  MyTextField(
                    controller: controller.usernameFieldController,
                    validator: validateUsername,
                    hintText: "Username",
                    prefixIcon: Icons.person, fillColor: ColorHelper.primaryColor,
                  ),
                  15.spaceY,
                  MyTextField(
                    controller: controller.emailFieldController,
                    validator: validateEmail,
                    hintText: "Email",
                    prefixIcon: Icons.email_outlined,
                    fillColor: ColorHelper.primaryColor,
                    // onChanged: (String? val){
                    //     if (val == null || val.isEmpty) {
                    //       controller.isEmailVerified.value=false;
                    //       return;
                    //     } else if (!isValidEmail(val)) {
                    //       controller.isEmailVerified.value=false;
                    //       return;
                    //     }
                    //     controller.isEmailVerified.value=true;
                    // },
                  ),
                  // 5.spaceY,
                  // Obx(
                  //   () {
                  //     return Visibility(
                  //       visible: controller.isEmailVerified.isTrue,
                  //       child: Align(
                  //         alignment: Alignment.topRight,
                  //         child: TextButton(
                  //             style: ButtonStyle(
                  //               backgroundColor: MaterialStateProperty.all<Color>(ColorHelper.primaryColor),
                  //               foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                  //               overlayColor: MaterialStateProperty.all<Color>(Colors.blueAccent.withOpacity(0.2)),
                  //               padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0)),
                  //               shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  //                 RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(12.0),
                  //                 ),
                  //               ),
                  //             ),
                  //           onPressed: (){
                  //           controller.verifyEmail();
                  //           }, child: Text("Verify Email")),
                  //       ),
                  //     );
                  //   }
                  // ),
                  
                  
                  15.spaceY,
        
                  Obx(() => Column(
                        children: [
                          Focus(
                            onFocusChange: controller.passwordFieldOnFocusChanged,
                            child: MyTextField( fillColor: ColorHelper.primaryColor,
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
                  MyTextField( fillColor: ColorHelper.primaryColor,
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
                    onPress: () async {
                      if (controller.signupFormKey.currentState!.validate()) {
                        // controller.createUser();
                        if(controller.isEmailVerified.isFalse){
                         bool response=await controller.verifyEmail();
                         if(response==false){
                          DefaultSnackbar.show("Error", "Something went wrong try again");
                          return;
                         }
                          DefaultSnackbar.show("Success", "Email verified successfully!");
                        }
                        controller.moveToSecurityKeyScreen();
                      } else {
                        DefaultSnackbar.show("Error", "Please enter valid info");
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
      ),
    );
  }
}
