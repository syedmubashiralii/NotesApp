import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../widgets/custom_switch.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    NotesController notesController = Get.find();

    RxBool sharingEnabled = true.obs;
    RxString appVersion = "".obs;
    PackageInfo.fromPlatform().then((value) {
      appVersion.value = value.version;
    });

    TextStyle heading1Style =
        GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 15);
    TextStyle? heading2Style =
        GoogleFonts.poppins(fontWeight: FontWeight.normal, fontSize: 13);

    return Scaffold(
        backgroundColor: ColorHelper.primaryDarkColor,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                size: 32,
              ),
              onPressed: () {
                Get.back();
              }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("Settings",
              style:
                  GoogleFonts.poppins(fontSize: AppConstants.kAppbarFontSize)),
        ),
        body: Padding(
            padding: EdgeInsets.all(AppConstants.kScreenPadding + 12),
            child: ListView(
              children: [
                Text(
                  "Display Options",
                  style: heading1Style,
                ),
                10.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Show Folders",
                      style: heading2Style,
                    ),
                    Obx(() {
                      return CustomSwitch(
                          value: notesController.showFolders.value,
                          onChanged: (value) {
                            notesController.showFolders.value = value;
                            notesController.box.write("showFolders", value);
                          });
                    })
                  ],
                ),
                10.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Theme",
                      style: heading2Style,
                    ),
                    InkWell(
                      onTap: () {
                        HelperFunction.openColorPicker();
                      },
                      child: CircleAvatar(
                        backgroundColor: ColorHelper.primaryColor,
                        radius: 22,
                      ),
                    )
                  ],
                ),
                20.spaceY,
                Text(
                  "Language",
                  style: heading1Style,
                ),
                10.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "App Language",
                      style: heading2Style,
                    ),
                    Obx(() {
                      return Text(
                        notesController.appLanguage.value,
                        style: heading2Style,
                      );
                    })
                  ],
                ),
                20.spaceY,
                Text(
                  "Sharing",
                  style: heading1Style,
                ),
                10.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Enable Sharing",
                      style: heading2Style,
                    ),
                    Obx(() {
                      return CustomSwitch(
                        value: sharingEnabled.value,
                        onChanged: (value) {
                          sharingEnabled.value = value;
                        },
                      );
                      // CupertinoSwitch(
                      //   activeColor: ColorHelper.primaryColor,
                      //   thumbColor: ColorHelper.primaryColor,
                      //   value: sharingEnabled.value,
                      //   onChanged:  (value) {
                      //                           sharingEnabled.value = value;
                      //                         }
                      // );
                    })
                  ],
                ),
                20.spaceY,
                Text(
                  "Encrypt / Decrypt",
                  style: heading1Style,
                ),
                10.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Allow fingerprint or face",
                      style: heading2Style,
                    ),
                    Obx(() {
                      return CustomSwitch(
                          value: notesController.useLocalAuth.value,
                          onChanged: (value) {
                            notesController.useLocalAuth.value = value;
                            notesController.setLocalAuth(value);
                          });
                    })
                  ],
                ),
                10.spaceY,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Always allow master password",
                            style: heading2Style,
                          ),
                          Text(
                            "Closing master password means it will be required only once.",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.normal,
                                fontSize: 10,
                                color: ColorHelper.blackColor.withAlpha(140)),
                          ),
                        ],
                      ),
                    ),
                    Obx(() {
                      return CustomSwitch(
                          value:
                              notesController.alwaysRequireMasterPassword.value,
                          onChanged: (value) {
                            notesController.alwaysRequireMasterPassword.value =
                                value;
                          });
                    })
                  ],
                ),
                40.spaceY,
                Text(
                  "About",
                  style: heading1Style,
                ),
                10.spaceY,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Application version",
                      style: heading2Style,
                    ),
                    Obx(() {
                      return Text(
                        appVersion.value,
                        style: heading2Style,
                      );
                    })
                  ],
                )
              ],
            )));
  }
}
