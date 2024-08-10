part of "../controllers/auth_controller.dart";

class _SecureStorageProvider {
  late final FlutterSecureStorage _storage;

  // String? email,
  //     username,
  //     password,
  //     passwordHint,
  //     encryptionKey,
  //     securityQuestion,
  //     securityQuestionAnswer;

  UserModel? userModel;

  _SecureStorageProvider() {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );

    // final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);

    _storage = FlutterSecureStorage(
      aOptions: getAndroidOptions(),
    );
  }

  Future<void> writeSecureData(String key, String value) async {
    try {
      logInfo("$key : $value");
      await _storage.write(key: key, value: value);
    } catch (e) {
      rethrow;
    }
  }

  readSecureData(String key) async {
    String value = await _storage.read(key: key) ?? 'No data found!';
    logInfo('Data read from secure storage: $value');
  }

  Future<UserModel?> readAllValues() async {
    if (userModel == null) {
      
      Map<String, String> allValues = await _storage.readAll();
      logJSON(message: "all values", object: allValues);
      // if user exist then email will exist
      if (allValues.containsKey(MapKey.userEmail)&&allValues.containsKey(MapKey.userAuthToken)) {
        print('enter');
        userModel = UserModel.fromJson(allValues);
      } else {
        return null;
      }
    }

    return userModel;
  }

  Future<bool> canUseLocalAuth() async {
    String value = await _storage.read(key: 'fingerprint_enabled') ?? 'false';
    logInfo('fingerprint_enabled: $value');
    return value == 'true' ? true : false;
  }

  Future<void> setLocalAuth(bool value) async {
    await _storage.write(
        key: 'fingerprint_enabled', value: value ? 'true' : 'false');
  }

  deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  Future<bool> verifyMasterPasswordStatus() async {
    String value =
        await _storage.read(key: 'master_password_enabled') ?? 'true';
    logInfo('fingerprint_enabled: $value');
    return value == 'true' ? true : false;
  }

  Future<void> changeMasterPasswordStatus(bool value) async {
    await _storage.write(
        key: 'master_password_enabled', value: value ? 'true' : 'false');
  }
}
