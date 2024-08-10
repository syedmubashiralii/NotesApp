class LoggedInUserModel {
  final int id;
  final String username;
  final String email;
  final String passwordHint;
  final String encryptionKey;
  final String masterPassword;
  final String passwordRecoveryQuestion;
  final String passwordRecoveryQuestionAnswer;
  final String authToken;

  LoggedInUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHint,
    required this.encryptionKey,
    required this.masterPassword,
    required this.passwordRecoveryQuestion,
    required this.passwordRecoveryQuestionAnswer,
    required this.authToken,
  });

  // Method to convert JSON to a User object
  factory LoggedInUserModel.fromJson(Map<String, dynamic> json) {
    return LoggedInUserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      passwordHint: json['passwordHint'],
      encryptionKey: json['encryptionKey'],
      masterPassword: json['masterPassword'],
      passwordRecoveryQuestion: json['passwordRecoveryQuestion'],
      passwordRecoveryQuestionAnswer: json['passwordRecoveryQuestionAnswer'],
      authToken: json['auth_token'],
    );
  }
}
