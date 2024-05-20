mixin CustomValidators {
  String? validateEmail(value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!isValidEmail(value)) {
      return "Invalid email format ( _@_.__ )";
    }
    return null;
  }

  bool isValidEmail(String email) {
    return RegExp(
            r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)+[a-zA-Z]{1,7}$')
        .hasMatch(email);
  }

  String? validatePassword(value) {
    if (value == null || value.isEmpty) {
      return "Enter password";
    } else if (!_isValidSecurityKey(value)) {
      return "Enter valid password";
    } else {
      return null;
    }
  }

  bool _isValidPassword(String val) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d!).{8,}$').hasMatch(val);
  }

  String? validateSecurityKey(value) {
    if (value == null || value.isEmpty) {
      return "Enter security key";
    } else if (!_isValidSecurityKey(value)) {
      return "Enter valid security key";
    } else {
      return null;
    }
  }

  bool _isValidSecurityKey(String val) {
    return RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[.,*@^!]).{8,}$')
        .hasMatch(val);
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter username";
    } else if (value.length < 3) {
      return "Username should have minimum 3 characters.";
    } else {
      return null;
    }
  }

  String? validateMasterPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter master password";
    } else {
      return null;
    }
  }

  String? validatePasswordHint(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter password hint";
    } else {
      return null;
    }
  }

  String? validateSecurityQuestionAnswer(String? value) {
    if (value == null || value.isEmpty) {
      return "Provide answer for recovery question";
    } else {
      return null;
    }
  }
}
