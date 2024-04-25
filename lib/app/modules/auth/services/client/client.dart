import 'package:notes_final_version/app/modules/auth/models/user_model.dart';

import 'api.dart';

class ApiService {
  API api = API();

  createNewUser(UserModel userModel) async {
    final response =
        await api.post(ApiEndPoints.registerUser, data: userModel.toApiJson());

    bool status = response['status'];
    if (status) {
      return true;
    } else {
      throw response['message'];
    }
  }
}

class ApiEndPoints {
  static const registerUser = 'register_user';
}
