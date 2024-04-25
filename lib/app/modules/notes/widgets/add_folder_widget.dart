import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/folders_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/folders_model.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/widgets/default_snackbar.dart';
import 'package:notes_final_version/app/utils/widgets/gradient_Button.dart';
import 'package:uuid/uuid.dart';

class AddFolderBottomSheet extends StatelessWidget {
  AddFolderBottomSheet({
    super.key,
  });
  FoldersController foldersController = Get.find();

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
                  'Add Folder',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
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
                controller: foldersController.titleController,
                // focusNode: focusNode,
                keyboardType: TextInputType.text,
                onChanged: (value) {},
                onSubmitted: (val) {
                  if (foldersController.titleController.text.isEmpty) {
                    DefaultSnackbar.show("Trouble", "Please enter folder name");
                  } else {
                    final String uid = const Uuid().v4();
                    foldersController.addUpdateFolder(FolderModel(
                        uid: uid,
                        name: foldersController.titleController.text,
                        date: DateTime.now()));
                    // HelperFunction.closeKeyboard(context);
                    Get.back();
                  }
                },
                onEditingComplete: () {},
                onTapOutside: (v) {
                  // HelperFunction.closeKeyboard(context);
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.title),
                  border: InputBorder.none,
                  hintStyle: MyTextStyle.normalBlack.copyWith(fontSize: 14),
                  hintText: "Folder Name",
                ),
              ),
            ),
            20.spaceY,
            GradientButton(
                text: "Add",
                icon: null,
                onPress: () {
                  if (foldersController.titleController.text.isEmpty) {
                    DefaultSnackbar.show("Trouble", "Please enter folder name");
                  } else {
                    final String uid = const Uuid().v4();
                    foldersController.addUpdateFolder(FolderModel(
                        uid: uid,
                        name: foldersController.titleController.text,
                        date: DateTime.now()));
                    // HelperFunction.closeKeyboard(context);
                    // focusNode.unfocus();
                    Get.back();
                  }
                }),
            30.spaceY,
          ],
        ),
      ),
    );
  }
}
