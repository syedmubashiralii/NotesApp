import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/labels_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/widgets/folder_menu.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';
import 'package:notes_final_version/app/utils/widgets/default_snackbar.dart';

class NoteHeader extends StatelessWidget {
  NoteHeader(
      {Key? key,
      required TextEditingController titleController,
      this.editNoteMod = false,
      required this.selected})
      : _titleController = titleController,
        super(key: key);

  final TextEditingController _titleController;
  final ValueNotifier<String?> selected;
  final bool editNoteMod;

  NotesController notesController = Get.find();
  LabelsController labelsController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _titleController,
          minLines: 1,
          autofocus: editNoteMod ? false : true,
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.next,
          style: GoogleFonts.ubuntu(
            textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w600),
          ),
          decoration: InputDecoration(
              fillColor: Theme.of(context).primaryColor,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              border: InputBorder.none,
              hintText: 'Title'),
        ),
        SizedBox(
            height: 40,
            child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 0),
                scrollDirection: Axis.horizontal,
                children: [
                  // Container(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text('Date: ${Jiffy(DateTime.now()).yMMMEdjm} ',
                  //         style: GoogleFonts.ubuntu(
                  //             fontSize: 14, color: Colors.black))),
                  FolderMenu(
                    selected: selected,
                  ),

                  Obx(() {
                    return notesController.labels.isEmpty
                        ? InkWell(
                            onTap: () {
                              if (labelsController.labelsList.isEmpty) {
                                DefaultSnackbar.show("Trouble",
                                    "No labels found, please create label first");
                              } else {
                                HelperFunction.addLabelSheet();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black)),
                              child: const Row(
                                children: [
                                  Icon(Icons.add),
                                  Text("Add label"),
                                ],
                              ),
                            ),
                          )
                        : Row(
                            children: [
                              const Text(
                                "Labels:",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              for (int i = 0;
                                  i < notesController.labels.length + 1;
                                  i++)
                                if (i == notesController.labels.length) ...{
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (labelsController
                                                .labelsList.value.isEmpty) {
                                              DefaultSnackbar.show("Trouble",
                                                  "No labels found, please create label first");
                                            } else {
                                              HelperFunction.addLabelSheet();
                                            }
                                          },
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                ColorHelper.primaryColor,
                                            child: const Icon(Icons.add),
                                          ),
                                        ),
                                        const Text("Add label"),
                                      ],
                                    ),
                                  )
                                } else ...{
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    padding: const EdgeInsets.only(
                                      right: 12,
                                    ),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            radius: 16,
                                            backgroundColor:
                                                ColorHelper.primaryColor,
                                            child: Text(notesController
                                                .labels[i][0]
                                                .toString())),
                                        5.SpaceY,
                                        Text(notesController.labels[i]),
                                      ],
                                    ),
                                  )
                                }
                            ],
                          );
                  }),
                ]))
      ],
    );
  }
}
