import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});

  NotesController notesController = Get.find();
  @override
  Widget build(BuildContext context) {
    RxBool sharingEnabled = true.obs;
    RxString appVerion = "".obs;
    PackageInfo.fromPlatform().then((value) {
      appVerion.value = value.version;
    });
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
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
                10.SpaceX,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Show Folders",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    Obx(() {
                      return CupertinoSwitch(
                          activeColor: ColorHelper.primaryColor,
                          thumbColor: ColorHelper.primaryColor,
                          value: notesController.showFolders.value,
                          onChanged: (value) {
                            notesController.showFolders.value = value;
                            notesController.box.write("showFolders", value);
                          });
                    })
                  ],
                ),
                10.SpaceX,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Select Theme",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 13),
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
                20.SpaceX,
                Text(
                  "Language",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
                10.SpaceX,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "App Language",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    Obx(() {
                      return Text(
                        notesController.appLanguage.value,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal, fontSize: 13),
                      );
                    })
                  ],
                ),
                20.SpaceX,
                Text(
                  "Sharing",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
                10.SpaceX,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Enable Sharing",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    Obx(() {
                      return CupertinoSwitch(
                          activeColor: ColorHelper.primaryColor,
                          thumbColor: ColorHelper.primaryColor,
                          value: sharingEnabled.value,
                          onChanged: (value) {
                            sharingEnabled.value = value;
                          });
                    })
                  ],
                ),
                40.SpaceX,
                Text(
                  "About",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, fontSize: 15),
                ),
                10.SpaceX,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Application version",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 13),
                    ),
                    Obx(() {
                      return Text(
                        appVerion.value,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.normal, fontSize: 13),
                      );
                    })
                  ],
                )
              ],
            )));
  }
}
