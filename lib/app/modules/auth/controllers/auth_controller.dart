import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as d;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_final_version/app/modules/auth/models/Login_user_model.dart';
import 'package:notes_final_version/app/utils/utils.dart';

import '../models/user_model.dart';
import 'signup_controller.dart';

part '../providers/secure_storage_provider.dart';

class AuthController extends GetxController implements PasswordCheckController {
  final _SecureStorageProvider _storageProvider = _SecureStorageProvider();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  LoggedInUserModel? loggedInUser;

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  // Password validation
  RxBool isPasswordFocused = false.obs;
  String lines =
      "8 characters minimum\nOne uppercase and one lowercase\nOne number minimum\nOne special character minimum .,*@^! ";
  @override
  late List<String> lineList = lines.split('\n');
  final RegExp uppercaseRegex = RegExp(r'[A-Z]');
  final RegExp lowercaseRegex = RegExp(r'[a-z]');
  final RegExp numberRegex = RegExp(r'[0-9]');
  final RegExp specialCharacterRegex = RegExp(r'[.,*@^!]');

  @override
  RxList<bool> passwordChecks = <bool>[false, false, false, false].obs;
  @override
  RxList<bool> securityKeyChecks = <bool>[false, false, false, false].obs;

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

  addValue() {
    _storageProvider.deleteSecureData('key');
  }

  Future<void> saveUserLocally(
      {
      required var id,  
      required String username,
      required String email,
      required String password,
      required String passwordHint,
      required String encryptionKey,
      required String masterPassword,
      required String passwordRecoveryQuestion,
      required String passwordRecoveryQuestionAnswer,required String authToken}) async {
    try {
      await _storageProvider.writeSecureData(MapKey.userName, username);
      await _storageProvider.writeSecureData(MapKey.userEmail, email);
      await _storageProvider.writeSecureData(MapKey.userPassword, password);
      await _storageProvider.writeSecureData(
          MapKey.userPasswordHint, passwordHint);
      await _storageProvider.writeSecureData(
          MapKey.userEncryptionKey, encryptionKey);
      await _storageProvider.writeSecureData(
          MapKey.userMasterPassword, masterPassword);
      await _storageProvider.writeSecureData(
          MapKey.userPasswordRecoveryQuestion, passwordRecoveryQuestion);
      await _storageProvider.writeSecureData(
          MapKey.userPasswordRecoveryQuestionAnswer,
          passwordRecoveryQuestionAnswer);
           await _storageProvider.writeSecureData(
      await  MapKey.userAuthToken,
          authToken);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> checkUserExist() async {
    try {
      UserModel? userModel = await _storageProvider.readAllValues();
  //  print("UserModel auth token${userModel!.authToken??""}");
      if (userModel != null) {
        loggedInUser=LoggedInUserModel(id: userModel.id??-1, username: userModel.username??"", email: userModel.email??"", passwordHint: userModel.passwordHint??"", encryptionKey: userModel.encryptionKey??"", masterPassword: userModel.masterPassword??"", passwordRecoveryQuestion: userModel.recoveryQuestion??"", passwordRecoveryQuestionAnswer: userModel.recoveryQuestionAnswer??"", authToken: userModel.authToken??"");
        return userModel;
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  // ************ Local auth ****************

  final LocalAuthentication auth = LocalAuthentication();
  RxBool canAuthenticate = false.obs;
  Rx<bool>? hasFingerprintAuth = false.obs, hasFaceAuth = false.obs;
  bool? canAuthenticateWithBiometrics;

  List<BiometricType>? availableBiometrics;

  canAuthenticateLocally() async {
    canAuthenticateWithBiometrics ??= await auth.canCheckBiometrics;
    logAnimatedText(
        "checkBiometrics canAuthenticateWithBiometrics :$canAuthenticateWithBiometrics");

    // todo here we will check android version above 8 or not
    canAuthenticate.value =
        canAuthenticateWithBiometrics! || await auth.isDeviceSupported();
    logAnimatedText("checkBiometrics canAuthenticate :$canAuthenticate");

    availableBiometrics ??= await auth.getAvailableBiometrics();
    logAnimatedText("availableBiometrics :$availableBiometrics");

    if (availableBiometrics!.isEmpty) {
      // Some biometrics are enrolled.
      canAuthenticate.value = false;
    } else {
      canAuthenticate.value = true;

      // if (availableBiometrics!.contains(BiometricType.face)) {
      //   hasFaceAuth!.value = true;
      //   canAuthenticate = true;
      // }
      // if (availableBiometrics!.contains(BiometricType.fingerprint)) {
      //   hasFingerprintAuth!.value = true;
      //   canAuthenticate = true;
      // }
    }
  }

  Future<bool> authWithBiometric() async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to access your notes data',
          options: const AuthenticationOptions(
              // biometricOnly: true,
              ));
      if (didAuthenticate) {
        logSuccess("Successfully authenticated");
        return true;
      } else {
        logError("Error in authentication");
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  userSigninOnServer() async {
    MyDialogs.showLoadingDialog();
    var headers = {'Accept': 'application/json', 'X-API-Key': 'KhurramShahzad'};
    var data = d.FormData.fromMap({
      'email': emailFieldController.text,
      'password': passwordFieldController.text
    });

    var dio = d.Dio();
    var response = await dio.request(
      '${AppConstants.BASE_URL}/api/signin',
      options: d.Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    Get.back();

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      if (response.data["status"] == true) {
        loggedInUser =
            LoggedInUserModel.fromJson(response.data["data"]["user"]);
         await saveUserLocally(
          id: loggedInUser!.id??-1,
            username: loggedInUser!.username??"",
            email: loggedInUser!.email??"",
            password: "",
            passwordHint: loggedInUser!.passwordHint??"",
            encryptionKey: loggedInUser!.encryptionKey??"",
            masterPassword: loggedInUser!.masterPassword??"",
            passwordRecoveryQuestion:
                loggedInUser!.passwordRecoveryQuestion??"",
            passwordRecoveryQuestionAnswer:
                loggedInUser!.passwordRecoveryQuestionAnswer??"",
                authToken: loggedInUser!.authToken??"");
                Get.back();
          DefaultSnackbar.show("Success", "Login Successfull!");      
        print(loggedInUser!.email.toString());
      }
      else{
        DefaultSnackbar.show("Error", response.data["message"]);
      }
    } else {
      print(response.statusMessage);
      DefaultSnackbar.show("Error", "Please check your credentials and try again");
      }
  }
  Future<bool> resetPassword() async {
    MyDialogs.showLoadingDialog();
    var headers = {'Accept': 'application/json', 'X-API-Key': 'KhurramShahzad'};
    var data = d.FormData.fromMap({
      'email': emailFieldController.text,
    });

    var dio = d.Dio();
    var response = await dio.request(
      '${AppConstants.BASE_URL}/api/password_recovery',
      options: d.Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
    Get.back();
    print(response.data);
    if(response.statusCode==200&&response.data["status"]==true)
    {
      DefaultSnackbar.show("Success", response.data["message"]);
      return true;
    }
    DefaultSnackbar.show("Failure", "Something went wrong, please check your email and try again");
    return false;
  }

  Future<bool> canUseLocalAuth() async {
    return await _storageProvider.canUseLocalAuth();
  }

  Future<void> setLocalAuth(bool value) async {
    await _storageProvider.setLocalAuth(value);
  }

  // ************ Local auth ended ****************

  @override
  void onReady() {
    super.onReady();
    passwordChecks.value = List.generate(lineList.length, (index) => false);
  }

  Future<bool> verifyMasterPasswordStatus() async {
    return await _storageProvider.verifyMasterPasswordStatus();
  }

  Future<void> changeMasterPasswordStatus(bool value) async {
    _storageProvider.changeMasterPasswordStatus(value);
  }
}
