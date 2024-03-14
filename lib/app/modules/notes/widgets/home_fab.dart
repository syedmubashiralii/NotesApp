import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/views/create_note.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';

class HomeFAB extends StatelessWidget {
  const HomeFAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 15),
      child: FloatingActionButton(
        onPressed: () {
          
          Get.to(() => CreateNote());
        },
        backgroundColor: ColorHelper.primaryColor,
        child: const Icon(
          Icons.add_outlined,
          color: ColorHelper.blackColor,
        ),
      ),
    );
  }
}
