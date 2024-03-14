import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/folders_controller.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/extensions.dart';

class FolderMenu extends StatelessWidget {
  FolderMenu({
    super.key,
    required this.selected,
  });

  ValueNotifier<String?> selected;

  FoldersController foldersController = Get.find();
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showMenu(
              context: context,
              position: RelativeRect.fromLTRB(
                  Get.width * .1, Get.height * .23, Get.width * .5, 0),
              items: List.generate(
                foldersController.foldersList.length,
                (index) => PopupMenuItem(
                    onTap: () {
                      selected.value =
                          foldersController.foldersList[index]!.name;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.folder,
                          color: Colors.amber,
                        ),
                        10.SpaceY,
                        Container(
                            constraints: const BoxConstraints(maxWidth: 150),
                            child: Text(
                              foldersController.foldersList[index]!.name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            )),
                      ],
                    )),
              ));
        },
        child: ValueListenableBuilder(
          valueListenable: selected,
          builder: ((context, value, child) => Text(
                'Folder: $value',
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: ColorHelper.blackColor,
                    // decoration: TextDecoration.underline,
                    fontWeight: FontWeight.w600),
              )),
        ));
  }
}
