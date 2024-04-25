import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/labels_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/labels_model.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/views/archived_notes.dart';
import 'package:notes_final_version/app/modules/notes/views/labels_view.dart';
import 'package:notes_final_version/app/modules/notes/views/settings_view.dart';
import 'package:notes_final_version/app/routes/app_pages.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/extensions.dart';
import 'package:notes_final_version/app/utils/widgets/custom_nav_item.dart';
import 'package:uuid/uuid.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LabelsController labelsController = Get.find();
    final NotesController notesController = Get.find();

    return Material(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: ColorHelper.primaryDarkColor,
            border: Border(right: BorderSide(color: ColorHelper.primaryColor))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.spaceY,
            InkWell(
              onTap: () => notesController.toggleDrawer(),
              child: CircleAvatar(
                backgroundColor: ColorHelper.primaryColor,
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
            10.spaceY,
            Image.asset(ImageAsset.notesIcon),
            15.spaceY,
            CustomNavTile(
                title: 'Notes',
                icon: Icons.home_outlined,
                selected: true, //_fragmentIndex == 0,
                onTap: () {
                  notesController.toggleDrawer();
                }),
            5.spaceY,
            CustomNavTile(
                title: 'Todos',
                icon: FontAwesomeIcons.checkSquare,
                selected: true, //_fragmentIndex == 0,
                onTap: () {
                  Get.toNamed(Routes.TODO);
                }),
            5.spaceY,
            CustomNavTile(
                title: 'Reminder',
                icon: FontAwesomeIcons.clock,
                selected: true, //_fragmentIndex == 0,
                onTap: () {
                  Get.toNamed(Routes.REMINDERS);
                }),
            5.spaceY,
            CustomNavTile(
                title: 'Archived Notes',
                icon: Icons.archive_outlined,
                selected: true, //_fragmentIndex == 0,
                onTap: () {
                  notesController.archivedNotesList.value = notesController
                      .getArchivedNotes()
                      .where((note) => note != null)
                      .cast<NoteModel>()
                      .toList();

                  Get.to(ArchivedNotes(),
                      transition: Transition.downToUp, curve: Curves.easeInOut);
                }),
            5.spaceY,
            CustomNavTile(
                title: 'Labels',
                icon: Icons.label_outline,
                selected: true,
                onTap: () {
                  if (kDebugMode && labelsController.labelsList.isEmpty) {
                    final String uid = const Uuid().v4();
                    labelsController.addLabel(LabelModel(
                        uid: uid, name: "new", date: DateTime.now()));
                  }

                  labelsController.labelsList.value = labelsController
                      .getAllLabels()
                      .where((label) => label != null)
                      .cast<LabelModel>()
                      .toList();

                  Get.to(LabelsView(),
                      transition: Transition.downToUp, curve: Curves.easeInOut);
                }),
            5.spaceY,
            Divider(
              color: ColorHelper.primaryColor,
            ),
            5.spaceY,
            CustomNavTile(
                title: 'Settings',
                icon: FontAwesomeIcons.cogs,
                selected: true,
                onTap: () {
                  Get.to(() => SettingsView(),
                      transition: Transition.downToUp, curve: Curves.easeInOut);
                }),
          ],
        ),
      ),
    );
  }
}
