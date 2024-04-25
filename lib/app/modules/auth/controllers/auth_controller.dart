import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:notes_final_version/app/utils/utils.dart';

import '../models/user_model.dart';
import 'signup_controller.dart';

part '../providers/secure_storage_provider.dart';

class AuthController extends GetxController implements PasswordCheckController {
  final _SecureStorageProvider _storageProvider = _SecureStorageProvider();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

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
      {required String username,
      required String email,
      required String password,
      required String passwordHint,
      required String encryptionKey,
      required String masterPassword,
      required String passwordRecoveryQuestion,
      required String passwordRecoveryQuestionAnswer}) async {
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
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> checkUserExist() async {
    try {
      UserModel? userModel = await _storageProvider.readAllValues();
      if (userModel != null) {
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

  Future<bool> canUseLocalAuth() async {
    return await _storageProvider.canUseLocalAuth();
  }

  Future<void> setLocalAuth(bool value) async {
    await _storageProvider.setLocalAuth(value);
  }

  // ************ Local auth ended ****************

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    passwordChecks.value = List.generate(lineList.length, (index) => false);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
