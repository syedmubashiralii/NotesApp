import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/folders_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/widgets/notes_cards.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';

class FoldersView extends StatelessWidget {
  FoldersView({super.key});
  FoldersController foldersController = Get.find();
  NotesController notesController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryDarkColor,
      body: Padding(
        padding: EdgeInsets.all(AppConstants.kScreenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Folders",
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w600),
            ),
            20.SpaceX,
            Expanded(
              child: Obx(() {
                return ListView.separated(
                  itemCount: foldersController.foldersList.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: ColorHelper.primaryColor,
                      thickness: 1,
                    );
                  },
                  itemBuilder: (context, index) {
                    var folder = foldersController.foldersList[index];
                    return ListTile(
                      onTap: () {
                        notesController.notesList.value = notesController
                            .getAllNotes(folderName: folder.name)
                            .where((note) => note != null)
                            .cast<NoteModel>()
                            .toList();
                        notesController.searchedNotesList.value = <NoteModel>[];
                        notesController.searchedNotesList.clear();
                        notesController.searchController.value.clear();
                        Get.to(NoteCards(
                          folderName: folder.name,
                        ));
                      },
                      leading: Icon(
                        Icons.folder,
                        color: ColorHelper.primaryColor,
                      ),
                      title: Text(
                        folder!.name,
                        style: const TextStyle(),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
