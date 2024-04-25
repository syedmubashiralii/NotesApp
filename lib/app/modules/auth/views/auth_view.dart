import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:notes_final_version/app/utils/extensions.dart';

import '../../../utils/color_helper.dart';
import '../controllers/auth_controller.dart';
import 'login.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AuthView'),
        centerTitle: true,
      ),
      body:Login()
    );
  }
}

