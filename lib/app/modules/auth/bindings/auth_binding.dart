import 'package:get/get.dart';

import 'package:notes_final_version/app/modules/auth/controllers/signup_controller.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignUpController>(
      () => SignUpController(),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
