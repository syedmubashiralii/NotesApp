import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';

class HomeSearchWidget extends StatelessWidget {
  HomeSearchWidget({
    super.key,
  });

  final NotesController notesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () async {
            notesController.searchController.value.text = "";
            // HelperFunction.closeKeyboard(context);
            await HelperFunction.showFiltersSheet();
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorHelper.primaryColor,
                border:
                    Border.all(color: ColorHelper.blackColor.withOpacity(0.3))),
            child: SvgPicture.asset(
              ImageAsset.filterIcon,
              height: 25,
              width: 25,
              color: ColorHelper.blackColor,
            ),
          ),
        ),
        5.SpaceY,
        Expanded(child: Obx(() {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border:
                    Border.all(color: ColorHelper.blackColor.withOpacity(0.3)),
                color: ColorHelper.primaryColor,
                borderRadius: BorderRadius.circular(12)),
            child: TextField(
              controller: notesController.searchController.value,
              keyboardType: TextInputType.text,
              onChanged: (value) {
                if (value.isEmpty) {
                  notesController.searchedNotesList.value = <NoteModel>[];
                  notesController.searchedNotesList.clear();


                  
                } else {
                  notesController.searchNotes(value);
                }
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                border: InputBorder.none,
                hintStyle: MyTextStyle.normalBlack.copyWith(fontSize: 14),
                hintText: "Search by ${notesController.selectedFilter.value}",
              ),
            ),
          );
        })),
        // 5.SpaceY,
        // InkWell(
        //   onTap: () async {
        //     notesController.searchController.value.text = "";
        //     HelperFunction.closeKeyboard(context);
        //     await HelperFunction.showFiltersSheet();
        //   },
        //   child: Container(
        //     padding: const EdgeInsets.all(10),
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(12),
        //         color: ColorHelper.primaryColor,
        //         border:
        //             Border.all(color: ColorHelper.blackColor.withOpacity(0.3))),
        //     child: const Icon(Icons.sort),
        //   ),
        // )
      ],
    );
  }
}
