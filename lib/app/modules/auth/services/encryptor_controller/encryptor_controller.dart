import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/utils/console_log_functions.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'base_cryptor.dart';

part 'file_cryptor.dart';

// Initialize encryption controller on user successfully logged in
class EncryptionController extends GetxService {
  String? temporaryDirectoryPath;

  // Modify below object according to need
  _FileCryptor? _fileCryptor;

  final count = 0.obs;

  void increment() => count.value++;

  void decrement() {
    if (count.value > 0) {
      count.value--;
    }
  }

  @override
  void onInit() {
    // checkPathExist();
    // initializeEncryptorInstance(userPassword);
    super.onInit();
  }

  initializeEncryptorInstance(String secureKey) {
    // if (_fileCryptor == null) {
    String key = create16DigitKey(secureKey);
    _fileCryptor = _FileCryptor(
      key: key, //"qwertyuiop@#%^&*()_+1234567890,;",
      iv: key.substring(0, 8),
      dir: "richTestFiles",
      // useCompress: true,
    );
    // }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  inputPermission() async {
    PermissionStatus status = await Permission.storage.status;
    logInfo("status: $status");
    if (status.isDenied) {
      PermissionStatus pStatus = await Permission.storage.request();
      logInfo("pStatus: $pStatus");
    }
  }

  Future<String> encryptSalsa(String dataInString) async {
    // create function for inputting permission according to different OS version
    // await inputPermission();
    logInfo("start encryption: ${DateTime.now()}");
    try {
      // File outputDirectory = File("$temporaryDirectoryPath/encryptedData");
      // File encryptedFile = await _fileCryptor!.encryptSalsa20(
      //   dataInStringForm: dataInString,
      //   // inputFile: dataInString,
      //   outputFile: "${outputDirectory.path}/$fileName.aes",
      // );
      // logInfo(encryptedFile.absolute.path);
      // logInfo("end encryption: ${DateTime.now()}");
      String encryptedData = await _fileCryptor!
          .encryptStringWithSalsa(dataToEncrypt: dataInString);
      return encryptedData;
    } catch (e) {
      logInfo("exception: $e");
      throw "Error in encryption: $e";
    }
  }

  Future<String> decryptSalsa(String dataInString) async {
    logInfo("start decryption: ${DateTime.now()}");
    try {
      logInfo("decryptSalsa _fileCryptor?.key: ${_fileCryptor?.key}");
      logInfo("decryptSalsa _fileCryptor?.iv: ${_fileCryptor?.iv}");

      String decryptedData = await _fileCryptor!
          .decryptStringWithSalsa(dataToDecrypt: dataInString);

      return decryptedData;
    } catch (e) {
      logInfo("exception: $e");
      throw "Error in encryption: $e";
    }
  }

  checkPathExist() async {
    if (temporaryDirectoryPath == null) {
      logInfo("not exist");
      await getPath();
    } else {
      logInfo("yes exist: $temporaryDirectoryPath");
    }
  }

  getPath() async {
    Directory pathDirectory = await getApplicationDocumentsDirectory();
    logInfo("appDocumentsDir: $pathDirectory");
    temporaryDirectoryPath = pathDirectory.path;
  }

  String create16DigitKey(String userPassword) {
    String mergedString = userPassword + userPassword;
    while (true) {
      if (mergedString.length < 16) {
        mergedString = mergedString + userPassword;
      } else {
        break;
      }
    }

    return mergedString.substring(0, 16);
  }
}
