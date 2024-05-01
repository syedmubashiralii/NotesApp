import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';

import '../../../utils/utils.dart';
import '../../auth/models/user_model.dart';

class InputMasterPasswordBottomSheet extends StatelessWidget {
  InputMasterPasswordBottomSheet({super.key, required this.userModel});

  final UserModel userModel;
  final notesController = Get.find<NotesController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.primaryDarkColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0.0, -2.0),
            blurRadius: 4.0,
          ),
        ],
        // borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: 16.0,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Verification Required',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back(result: false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: ColorHelper.blackColor),
                  ),
                )
              ],
            ),
            Divider(
              thickness: 2,
              color: ColorHelper.primaryColor,
            ),
            20.spaceY,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorHelper.blackColor.withOpacity(0.3)),
                  color: ColorHelper.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: notesController.masterPasswordController,
                // focusNode: focusNode,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  // Limits input to 4 characters
                ],
                onChanged: (value) {},
                onSubmitted: (val) {
                  if (notesController.masterPasswordController.text.isEmpty) {
                    DefaultSnackbar.show(
                        "Trouble", "Please enter master password.");
                  } else {
                    if (notesController.masterPasswordController.text.trim() ==
                        userModel.masterPassword) {
                      successfullyAuthenticated();
                    } else {
                      DefaultSnackbar.show(
                          "Trouble", "Invalid master password.");
                    }
                  }
                },
                onEditingComplete: () {},
                onTapOutside: (v) {
                  // HelperFunction.closeKeyboard(context);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password),
                  border: InputBorder.none,
                  hintStyle: MyTextStyle.normalBlack.copyWith(fontSize: 14),
                  hintText: "Master Password",
                ),
              ),
            ),
            20.spaceY,
            Row(
              children: [
                Expanded(
                  child: GradientButton(
                      text: "Verify",
                      icon: null,
                      onPress: () {
                        if (notesController
                            .masterPasswordController.text.isEmpty) {
                          DefaultSnackbar.show(
                              "Trouble", "Please enter master password.");
                        } else {
                          if (notesController.masterPasswordController.text
                                  .trim() ==
                              userModel.masterPassword) {
                            successfullyAuthenticated();
                          } else {
                            DefaultSnackbar.show(
                                "Trouble", "Invalid master password.");
                          }
                        }
                      }),
                ),
                Obx(() {
                  return notesController.canAuthenticate()
                      ? IconButton(
                          icon: const Icon(Icons.fingerprint_outlined),
                          iconSize: 54,
                          color: ColorHelper.whiteColor,
                          onPressed: () async {
                            try {
                              if (notesController.useLocalAuth.value) {
                                bool authenticated =
                                    await notesController.authWithBiometric();
                                if (authenticated) {
                                  successfullyAuthenticated(
                                      fromFingerprint: true);
                                }
                              } else {
                                MyDialogs.showMessageDialog(
                                  title: 'Fingerprint disabled',
                                  description:
                                      "Please enable fingerprint from setting and try again.",
                                );

                                // showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         title: const Text(
                                //             'Fingerprint disabled'),
                                //         content: const Text(
                                //             'Please login with email/password and then enable biometric login in your profile.'),
                                //         actions: [
                                //           TextButton(
                                //               onPressed: () {
                                //                Get.back();
                                //               },
                                //               child: const Text('OK'))
                                //         ],
                                //       );
                                //     });
                              }
                            } catch (e) {
                              logError("error Icons.fingerprint : $e");
                              MyDialogs.showMessageDialog(
                                  title: "Error",
                                  description:
                                      "There is some error, please try again later.");
                            }
                          },
                        )
                      : SizedBox.shrink();
                })
              ],
            ),
            20.spaceY,
            Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      // HelperFunction.closeKeyboard(context);
                      HelperFunction.giveDelay();

                      Get.back();
                      notesController.masterPasswordRecoveryController.clear();
                      notesController.showMasterPasswordForRecovery.value =
                          false;
                      HelperFunction.giveDelay();

                      HelperFunction.showMasterPasswordRecoverySheet(userModel);
                    },
                    child: const Text("Recover password"))),
            15.spaceY,
          ],
        ),
      ),
    );
  }

  successfullyAuthenticated({bool fromFingerprint = false}) {
    if (!fromFingerprint &&
        notesController.alwaysRequireMasterPassword.value == false) {
      notesController.masterPasswordAsked.value = true;
      //todo   store it in shared prefs also
      notesController.changeMasterPasswordStatus(false);
    }
    Get.back(result: true);
  }
}

class MasterPasswordRecoveryBottomSheet extends StatelessWidget {
  MasterPasswordRecoveryBottomSheet({super.key, required this.userModel});

  final UserModel userModel;
  final notesController = Get.find<NotesController>();

  // FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorHelper.primaryDarkColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0.0, -2.0),
            blurRadius: 4.0,
          ),
        ],
        // borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: 16.0,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Password Recovery',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back(result: false);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: ColorHelper.blackColor),
                  ),
                )
              ],
            ),
            Divider(
              thickness: 2,
              color: ColorHelper.primaryColor,
            ),
            20.spaceY,
            Text(
              "${userModel.recoveryQuestion}",
              style: const TextStyle(color: ColorHelper.blackColor),
            ),
            15.spaceY,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: ColorHelper.blackColor.withOpacity(0.3)),
                  color: ColorHelper.primaryColor,
                  borderRadius: BorderRadius.circular(12)),
              child: TextField(
                controller: notesController.masterPasswordRecoveryController,
                // focusNode: focusNode,
                keyboardType: TextInputType.text,

                onChanged: (value) {},
                onSubmitted: (val) {
                  if (notesController
                      .masterPasswordRecoveryController.text.isEmpty) {
                    DefaultSnackbar.show("Trouble",
                        "Please enter answer for security question.");
                  } else {
                    if (notesController.masterPasswordRecoveryController.text
                            .trim() ==
                        userModel.recoveryQuestionAnswer) {
                      notesController.showMasterPasswordForRecovery.value =
                          true;
                      // Get.back(result: true);
                    } else {
                      DefaultSnackbar.show("Trouble", "Invalid answer.");
                    }
                  }
                },
                onEditingComplete: () {},
                onTapOutside: (v) {
                  // HelperFunction.closeKeyboard(context);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.question_answer),
                  border: InputBorder.none,
                  hintStyle: MyTextStyle.normalBlack.copyWith(fontSize: 14),
                  hintText: "Answer",
                ),
              ),
            ),
            20.spaceY,
            GradientButton(
                text: "Verify",
                icon: null,
                onPress: () {
                  if (notesController
                      .masterPasswordRecoveryController.text.isEmpty) {
                    DefaultSnackbar.show("Trouble",
                        "Please enter answer for security question.");
                  } else {
                    if (notesController.masterPasswordRecoveryController.text
                            .trim() ==
                        userModel.recoveryQuestionAnswer) {
                      notesController.showMasterPasswordForRecovery.value =
                          true;
                    } else {
                      DefaultSnackbar.show("Trouble", "Invalid answer.");
                    }
                  }
                }),
            20.spaceY,
            Obx(
              () => !notesController.showMasterPasswordForRecovery.value
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Your master password is "),
                            Text("${userModel.masterPassword}"),
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text("Close")),
                      ],
                    ),
            ),
            15.spaceY,
          ],
        ),
      ),
    );
  }
}
