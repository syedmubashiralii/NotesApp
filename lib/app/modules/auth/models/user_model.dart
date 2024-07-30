import 'package:notes_final_version/app/utils/map_keys.dart';

class UserModel {
  int? id;
      String? email,
      username,
      password,
      passwordHint,
      encryptionKey,
      recoveryQuestion,
      masterPassword,
      recoveryQuestionAnswer,
      authToken;

  UserModel(
      {this.id,
        this.email,
      this.username,
      this.password,
      this.passwordHint,
      this.encryptionKey,
      this.recoveryQuestion,
      this.recoveryQuestionAnswer,
      this.masterPassword,
      this.authToken});

  // Factory constructor to create UserModel from a map
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json[MapKey.userId],
        email: json[MapKey.userEmail],
        username: json[MapKey.userName],
        password: json[MapKey.userPassword],
        passwordHint: json[MapKey.userPasswordHint],
        encryptionKey: json[MapKey.userEncryptionKey],
        masterPassword: json[MapKey.userMasterPassword],
        recoveryQuestion: json[MapKey.userPasswordRecoveryQuestion],
        recoveryQuestionAnswer: json[MapKey.userPasswordRecoveryQuestionAnswer],
        authToken: json.containsKey(MapKey.userAuthToken)
            ? json[MapKey.userAuthToken]
            : null,
      );

  // Convert UserModel to a map
  Map<String, dynamic> toJson() => {
        MapKey.userEmail: email,
        MapKey.userName: username,
        MapKey.userPassword: password,
        MapKey.userPasswordHint: passwordHint,
        MapKey.userEncryptionKey: encryptionKey,
        MapKey.userMasterPassword: masterPassword,
        MapKey.userPasswordRecoveryQuestion: recoveryQuestion,
        MapKey.userPasswordRecoveryQuestionAnswer: recoveryQuestionAnswer,
        MapKey.userAuthToken: authToken,
      };

  Map<String, dynamic> toApiJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'name': username,
      'password': password,
      'password_hint': passwordHint,
      'encryption_key': encryptionKey,
      'master_password': masterPassword,
      'recovery_question': recoveryQuestion,
      'recovery_question_answer': recoveryQuestionAnswer,
      'authToken': authToken,
    };
    return data;
  }
}
