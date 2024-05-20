import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/auth/controllers/auth_controller.dart';
import 'package:notes_final_version/app/modules/auth/models/user_model.dart';
import 'package:notes_final_version/app/modules/auth/views/input_securit_key_view.dart';
import 'package:notes_final_version/app/utils/utils.dart';
import 'package:notes_final_version/app/utils/widgets/email_verification_sheet.dart';

import '../services/client/client.dart';

// Define the interface or superclass
abstract class PasswordCheckController {
  List<String> get lineList;

  RxList<bool> get passwordChecks;

  RxList<bool> get securityKeyChecks;
}

class SignUpController extends GetxController
    implements PasswordCheckController {
  AuthController authController = Get.find<AuthController>();
  RxBool isEmailVerified=false.obs;

  // Signup screen instances
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController usernameFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController passwordHintFieldController =
      TextEditingController();

  // ****** security screen instances
  final GlobalKey<FormState> securityFormKey = GlobalKey<FormState>();
  final TextEditingController securityKeyFieldController =
      TextEditingController();
  final TextEditingController masterPasswordFieldController =
      TextEditingController();

  // final TextEditingController recoveryQuestionFieldController =
  //     TextEditingController();
  final TextEditingController recoveryQuestionAnswerFieldController =
      TextEditingController();
  List<String> recoveryQuestionsList = [
    'What is your favourite dog breed?',
    'In which city you were born?',
    'What is your favourite color?'
  ];
  RxInt selectedRecoveryQuestion = 0.obs;

  String lines =
      "8 characters minimum\nOne uppercase and one lowercase\nOne number minimum\nOne special character minimum .,*@^! ";
  final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp lowercaseRegex = RegExp(r'[a-z]');
  final RegExp numberRegex = RegExp(r'[0-9]');
  final RegExp specialCharacterRegex = RegExp(r'[.,*@^!]');

  // *************** Password validation ***************
  RxBool isPasswordFocused = false.obs;

  @override
  late List<String> lineList = lines.split('\n');
  @override
  RxList<bool> passwordChecks = <bool>[false, false, false, false].obs;

  void passwordFieldOnFocusChanged(bool value) {
    isPasswordFocused.value = value;
  }

  void passwordFieldOnChange(String value) {
    String password = value;
    passwordChecks[0] = password.length >= 8;
    passwordChecks[1] =
        uppercaseRegex.hasMatch(password) && lowercaseRegex.hasMatch(password);
    passwordChecks[2] = numberRegex.hasMatch(password);
    passwordChecks[3] = specialCharacterRegex.hasMatch(password);
  }

  // ************* Password validation ended ***************

  // *************** Security Key validation ***************
  RxBool isSecurityKeyFocused = false.obs;

  @override
  RxList<bool> securityKeyChecks = <bool>[false, false, false, false].obs;

  void securityKeyFieldOnFocusChanged(bool value) {
    isSecurityKeyFocused.value = value;
  }

  void securityKeyFieldOnChange(String value) {
    String password = value;
    securityKeyChecks[0] = password.length >= 8;
    securityKeyChecks[1] =
        uppercaseRegex.hasMatch(password) && lowercaseRegex.hasMatch(password);
    securityKeyChecks[2] = numberRegex.hasMatch(password);
    securityKeyChecks[3] = specialCharacterRegex.hasMatch(password);
  }

  // ************* Security Key validation ended ***************

  createNewUser() {
    UserModel userModel = UserModel(
      username: usernameFieldController.text.trim(),
      email: emailFieldController.text.trim(),
      password: passwordFieldController.text.trim(),
      passwordHint: passwordHintFieldController.text.trim(),
      encryptionKey: securityKeyFieldController.text.trim(),
      masterPassword: masterPasswordFieldController.text.trim(),
      recoveryQuestion: recoveryQuestionsList[selectedRecoveryQuestion.value],
      recoveryQuestionAnswer: recoveryQuestionAnswerFieldController.text.trim(),
    );

    ApiService().createNewUser(userModel);
  }

  userSignUpOnServer() async {
    var headers = {'Accept': 'application/json', 'X-API-Key': 'KhurramShahzad'};
    var data = d.FormData.fromMap({
      'username': usernameFieldController.text,
      'email': emailFieldController.text,
      'password': passwordFieldController.text,
      'passwordHint': passwordHintFieldController.text,
      'encryptionKey': securityKeyFieldController.text,
      'masterPassword': masterPasswordFieldController.text,
      'passwordRecoveryQuestion':
          recoveryQuestionsList[selectedRecoveryQuestion.value],
      'passwordRecoveryQuestionAnswer':
          recoveryQuestionAnswerFieldController.text
    });

    var dio = d.Dio();
    var response = await dio.request(
      '${AppConstants.BASE_URL}/api/signup',
      options: d.Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    print(response.data);
    if (response.statusCode == 200) {
      if (response.data['status'] == false) {
        MyDialogs.closeDialog();
        MyDialogs.showMessageDialog(
            title: "Failure",
            description: response.data['message'],
            onConfirm: () {
              logInfo("Confirm tapped");
              Get.back();
            });
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  

  Future<bool> verifyEmail() async {
    MyDialogs.showLoadingDialog();
    var headers = {'Accept': 'application/json', 'X-API-Key': 'KhurramShahzad'};
    var data = d.FormData.fromMap({
      'email': emailFieldController.text,
    });

    var dio = d.Dio();
    var response = await dio.request(
      '${AppConstants.BASE_URL}/api/verify_email',
      options: d.Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    Get.back();
    print(response.data);
    if(response.statusCode==200){
      if(response.data["status"]==true){
        String? code = await EmailVerificationSheet(
              title: "Email Verification",
              subtitle:
                  "Please enter the OTP sent to your email ${emailFieldController.text}.",
              phoneNumber: "",
              digits: 6)
          .show();
        if (code != null&&int.parse(code)==response.data["data"]["verification_code"]) {
          return true;
        }
        return false;

      }
      return false;
    }
    return false;
  }

  

  createUser() async {
    try {
      logInfo();

      MyDialogs.showLoadingDialog(message: "Creating your account...");

      if (await userSignUpOnServer() == true) {
        await authController.saveUserLocally(
            username: usernameFieldController.text.trim(),
            email: emailFieldController.text.trim(),
            password: passwordFieldController.text.trim(),
            passwordHint: passwordHintFieldController.text.trim(),
            encryptionKey: securityKeyFieldController.text.trim(),
            masterPassword: masterPasswordFieldController.text.trim(),
            passwordRecoveryQuestion:
                recoveryQuestionsList[selectedRecoveryQuestion.value],
            passwordRecoveryQuestionAnswer:
                recoveryQuestionAnswerFieldController.text.trim());
        logSuccess("User created successfully");
        MyDialogs.closeDialog();
        await Future.delayed(const Duration(milliseconds: 200));

        MyDialogs.showMessageDialog(
            title: "Success",
            description:
                "Your account is registered, and security password is set. Now you can secure your notes.",
            onConfirm: () {
              logInfo("Confirm tapped");
              Get.back();
              Get.back();
              Get.back();
              Get.back();
            });
      } else {}

      // DefaultSnackbar.show("Success", "Account created successfully.");
    } catch (e) {
      logError("Error: $e");
      MyDialogs.closeDialog();
      DefaultSnackbar.show(
          "Trouble", "Unable to created your account, try again later.");
    }
  }

  moveToSecurityKeyScreen() {
    Get.to(() => const InputSecurityKeyView());
  }
}
