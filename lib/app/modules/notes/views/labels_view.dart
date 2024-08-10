import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/labels_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/labels_model.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/widgets/notes_cards.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/widgets/default_snackbar.dart';
import 'package:uuid/uuid.dart';

class LabelsView extends StatelessWidget {
  LabelsView({super.key});

  LabelsController labelsController = Get.find();
  NotesController notesController = Get.find();

  @override
  Widget build(BuildContext context) {
    RxInt selectedIndex = 50000.obs;
    RxBool isNewLabelClicked = false.obs;
    return PopScope(
      onPopInvoked: (val) {
        notesController.notesList.value = notesController
            .getAllNotes()
            .where((note) => note != null)
            .cast<NoteModel>()
            .toList();
      },
      child: Scaffold(
        backgroundColor: ColorHelper.primaryDarkColor,
        appBar: AppBar(
          leading: IconButton(
              icon: const Icon(
                Icons.close,
                size: 32,
              ),
              onPressed: () {
                notesController.notesList.value = notesController
                    .getAllNotes()
                    .where((note) => note != null)
                    .cast<NoteModel>()
                    .toList();
                Get.back();
              }),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: Text("labels",
              style:
                  GoogleFonts.poppins(fontSize: AppConstants.kAppbarFontSize)),
        ),
        body: Padding(
          padding: EdgeInsets.all(AppConstants.kScreenPadding),
          child: Column(
            children: [
              Obx(() {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: isNewLabelClicked.isTrue
                              ? Colors.black
                              : Colors.transparent)),
                  child: ListTile(
                    onTap: () {
                      selectedIndex.value = 50000;
                      isNewLabelClicked.value = true;
                    },
                    leading: InkWell(
                      onTap: isNewLabelClicked.isTrue
                          ? () {
                              isNewLabelClicked.value = false;
                            }
                          : () {
                              selectedIndex.value = 50000;
                              isNewLabelClicked.value = true;
                            },
                      child: Icon(
                        isNewLabelClicked.isTrue ? Icons.close : Icons.add,
                        color: ColorHelper.blackColor,
                        size: 28,
                      ),
                    ),
                    title: isNewLabelClicked.isTrue
                        ? TextField(
                            decoration: const InputDecoration(
                              hintText: 'Enter label name',
                              border: InputBorder.none,
                            ),
                            controller: labelsController.titleController,
                          )
                        : const Text(
                            "Create new label",
                            style: TextStyle(color: ColorHelper.blackColor),
                          ),
                    trailing: isNewLabelClicked.isTrue
                        ? InkWell(
                            onTap: () {
                              if (labelsController
                                  .titleController.text.isNotEmpty) {
                                final String uid = const Uuid().v4();

                                labelsController.addUpdateLabel(LabelModel(
                                    uid: uid,
                                    name: labelsController.titleController.text,
                                    date: DateTime.now()));

                                // HelperFunction.closeKeyboard(context);
                                labelsController.titleController.clear();
                                isNewLabelClicked.value = false;
                              } else {
                                //snackbar
                                DefaultSnackbar.show(
                                    "Trouble", "Please enter label name");
                              }
                            },
                            child: const Icon(Icons.done))
                        : null,
                  ),
                );
              }),
              10.spaceY,
              Expanded(child: Obx(() {
                return ListView.builder(
                  itemCount: labelsController.labelsList.length,
                  itemBuilder: (context, index) {
                    var label = labelsController.labelsList[index];
                    FocusNode focusNode = FocusNode();

                    return Obx(() {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: selectedIndex.value == index
                                    ? Colors.black
                                    : Colors.transparent)),
                        child: ListTile(
                          onTap: () {
                            // labelsController.titleController.text = label!.name;
                            // focusNode.requestFocus();
                            // selectedIndex.value = index;

                            notesController.notesList.value = notesController
                                .getAllNotes(labelName: label!.name)
                                .where((note) => note != null)
                                .cast<NoteModel>()
                                .toList();
                            notesController.searchedNotesList.value =
                                <NoteModel>[];
                            notesController.searchedNotesList.clear();
                            notesController.searchController.value.clear();
                            Get.to(NoteCards(
                              labelName: label.name,
                            ));
                          },
                          leading: InkWell(
                            onTap: selectedIndex.value == index
                                ? () {
                                    labelsController.deleteLabel(label!.uid);
                                  }
                                : () {},
                            child: Icon(
                              selectedIndex.value == index
                                  ? FontAwesomeIcons.trashAlt
                                  : Icons.label_outlined,
                              color: ColorHelper.blackColor,
                              size: selectedIndex.value == index ? 24 : 28,
                            ),
                          ),
                          title: selectedIndex.value == index
                              ? TextField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter label name',
                                    border: InputBorder.none,
                                  ),
                                  focusNode: focusNode,
                                  controller: labelsController.titleController,
                                )
                              : Text(
                                  label!.name,
                                  style: const TextStyle(
                                      color: ColorHelper.blackColor),
                                ),
                          trailing: InkWell(
                            onTap: selectedIndex.value != index
                                ? () {
                                    focusNode.requestFocus();
                                    labelsController.titleController.text =
                                        label!.name;
                                    selectedIndex.value = index;
                                  }
                                : () {
                                    if (labelsController
                                        .titleController.text.isNotEmpty) {
                                      selectedIndex.value = 50000;
                                      focusNode.unfocus();
                                      // HelperFunction.closeKeyboard(context);
                                      label!.name =
                                          labelsController.titleController.text;
                                      labelsController.addUpdateLabel(label);
                                      labelsController.titleController.clear();
                                    } else {
                                      DefaultSnackbar.show(
                                          "Trouble", "Please enter label name");
                                    }
                                  },
                            child: Icon(selectedIndex.value == index
                                ? Icons.done
                                : Icons.edit),
                          ),
                        ),
                      );
                    });
                  },
                );
              }))
            ],
          ),
        ),
      ),
    );
  }
}
