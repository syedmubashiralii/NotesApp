import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/widgets/gradient_Button.dart';

class FilterBottomSheet extends StatelessWidget {
  FilterBottomSheet({
    super.key,
  });
  NotesController notesController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            offset: const Offset(0.0, -2.0), // Negative y-offset for top shadow
            blurRadius: 4.0,
          ),
        ],
      ),
      // border: Border.all(color: Colors.black)),
      child: Container(
        decoration: BoxDecoration(
          color: ColorHelper.primaryDarkColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter by',
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
              const SizedBox(height: 16.0),
              Obx(() {
                return SizedBox(
                  width: Get.width,
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor:
                            ColorHelper.primaryColor, // color of tick Mark
                        activeColor: ColorHelper.blackColor,
                        value: notesController.selectedFilter.value == "Title"
                            ? true
                            : false,
                        onChanged: (_) =>
                            notesController.selectedFilter.value = "Title",
                      ),
                      const Text("Title"),
                    ],
                  ),
                );
              }),
              Obx(() {
                return SizedBox(
                  width: Get.width,
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor:
                            ColorHelper.primaryColor, // color of tick Mark
                        activeColor: ColorHelper.blackColor,
                        value: notesController.selectedFilter.value == "Content"
                            ? true
                            : false,
                        onChanged: (_) =>
                            notesController.selectedFilter.value = "Content",
                      ),
                      const Text("Content"),
                    ],
                  ),
                );
              }),
              Obx(() {
                return SizedBox(
                  width: Get.width,
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor:
                            ColorHelper.primaryColor, // color of tick Mark
                        activeColor: ColorHelper.blackColor,
                        value: notesController.selectedFilter.value == "Folder"
                            ? true
                            : false,
                        onChanged: (_) =>
                            notesController.selectedFilter.value = "Folder",
                      ),
                      const Text("Folder"),
                    ],
                  ),
                );
              }),
              Obx(() {
                return SizedBox(
                  width: Get.width,
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor:
                            ColorHelper.primaryColor, // color of tick Mark
                        activeColor: ColorHelper.blackColor,
                        value: notesController.selectedFilter.value == "Label"
                            ? true
                            : false,
                        onChanged: (_) =>
                            notesController.selectedFilter.value = "Label",
                      ),
                      const Text("Label"),
                    ],
                  ),
                );
              }),
              15.SpaceX,
              GradientButton(
                  text: "Apply Filter",
                  icon: null,
                  onPress: () {
                    notesController.searchController.value.text = "";
                    Get.back();
                  }),
              30.SpaceX,
            ],
          ),
        ),
      ),
    );
  }
}
