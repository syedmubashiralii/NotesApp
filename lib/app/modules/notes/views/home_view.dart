import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_final_version/app/modules/notes/controllers/folders_controller.dart';
import 'package:notes_final_version/app/modules/notes/views/create_note.dart';
import 'package:notes_final_version/app/modules/notes/views/folders_view.dart';
import 'package:notes_final_version/app/modules/notes/widgets/notes_cards.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';
import 'package:notes_final_version/app/utils/widgets/drawer_widget.dart';

import '../controllers/notes_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final NotesController notesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorHelper.primaryDarkColor,
      child: SafeArea(
          child: ZoomDrawer(
        controller: notesController.zoomDrawerController,
        mainScreen: MainScreen(),
        menuScreen: DrawerScreen(),
        borderRadius: 24.0,
        showShadow: true,
        menuBackgroundColor: ColorHelper.primaryDarkColor,
        openCurve: Curves.fastOutSlowIn,
        closeCurve: Curves.bounceIn,
        angle: -12.0,
        drawerShadowsBackgroundColor: Colors.grey,
        slideWidth: MediaQuery.of(context).size.width * 0.7,
      )),
    );
  }
}

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final NotesController notesController = Get.find();
  final FoldersController foldersController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryDarkColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.bars,
              size: 26,
            ),
            onPressed: () {
              notesController.toggleDrawer();
            }),
        backgroundColor: Colors.transparent,
        title: Text("KP Notes",
            style: GoogleFonts.poppins(fontSize: AppConstants.kAppbarFontSize)),
      ),

      // floatingActionButton: const HomeFAB(),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.kScreenPadding),
        child: Obx(() {
          return Column(children: [
            Expanded(
                child: notesController.showFolders.isTrue
                    ? FoldersView()
                    : NoteCards())
            // Expanded(child: NoteCards()),
          ]);
        }),
      ),
      bottomNavigationBar: SizedBox(
        height: Get.height * .08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  HelperFunction.showAddFolderSheet();
                },
                icon: const Icon(FontAwesomeIcons.folderPlus)),
            IconButton(
                onPressed: () {
                  notesController.titleController.clear();
                  notesController.quillController.clear();
                  notesController.labels.value = [];
                  Get.to(() => CreateNote());
                },
                icon: const Icon(FontAwesomeIcons.edit))
          ],
        ),
      ),
    );
  }
}
