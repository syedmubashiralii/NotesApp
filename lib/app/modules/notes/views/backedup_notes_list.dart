import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill_extensions/embeds/widgets/image.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:flutter_quill_extensions/models/config/shared_configurations.dart';
import 'package:flutter_quill_extensions/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_final_version/app/modules/notes/controllers/folders_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/labels_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/folders_model.dart';
import 'package:notes_final_version/app/modules/notes/models/labels_model.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/widgets/quill/embeds/timestamp_embed.dart';
import 'package:notes_final_version/app/utils/utils.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/models/config/image/editor/image_configurations.dart';
import 'package:uuid/uuid.dart';

class BackedUpNotes extends StatelessWidget {
  BackedUpNotes({super.key});
  final NotesController notesController = Get.find();
  final FoldersController foldersController = Get.find();
  final LabelsController labelsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryDarkColor,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(
              Icons.close,
              size: 32,
            ),
            onPressed: () {
              Get.back();
            }),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text("Backed Up Notes",
            style: GoogleFonts.poppins(fontSize: AppConstants.kAppbarFontSize)),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.kScreenPadding),
        child: Obx(() {
          return notesController.backedUpNotesList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.exclamationTriangle,
                        size: 48,
                        color: ColorHelper.primaryColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No backed up notes found',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    15.spaceY,
                    Expanded(
                      child: MasonryGridView.builder(
                          physics: const BouncingScrollPhysics(),
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5,
                          itemCount: notesController.backedUpNotesList.length,
                          gridDelegate:
                              const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: ((gridViewContext, index) {
                            NoteModel? noteData =
                                notesController.backedUpNotesList[index];

                            if (noteData == null) {
                              return const Text("Note is null");
                            }

                            return FocusedMenuHolder(
                              menuWidth: 200,
                              menuOffset: 10,
                              bottomOffsetHeight: 0,
                              menuBoxDecoration: const BoxDecoration(
                                  color: ColorHelper.blackColor),
                              animateMenuItems: false,
                              blurBackgroundColor: ColorHelper.blackColor,
                              onPressed: () {},
                              menuItems: [
                                FocusedMenuItem(
                                    trailingIcon: const Icon(
                                        Icons.cloud_download,
                                        color: ColorHelper.blackColor),
                                    title: const Text(
                                      'Restore',
                                      style: TextStyle(
                                          color: ColorHelper.blackColor),
                                    ),
                                    onPressed: () async {
                                      bool folderExists = foldersController
                                              .foldersList.isNotEmpty &&
                                          foldersController.foldersList.value
                                              .any((folder) =>
                                                  folder!.name.trim() ==
                                                  noteData.folder.trim());

                                      if (!folderExists) {
                                        final String uid = const Uuid().v4();
                                        foldersController.addFolder(FolderModel(
                                            uid: uid,
                                            name: noteData.folder,
                                            date: DateTime.now()));
                                      }

                                      for(var lbl in noteData.labels){
                                        bool labelExists = labelsController
                                              .labelsList.isNotEmpty &&
                                          labelsController.labelsList.value
                                              .any((label) =>
                                                  label!.name.trim() ==
                                                  lbl.toString().trim());

                                      if (!labelExists) {
                                        final String uid = const Uuid().v4();
                                        labelsController.addLabel(LabelModel(
                                            uid: uid,
                                            name: lbl,
                                            date: DateTime.now()));
                                      }
                                      }

                                      notesController.addUpdateNote(noteData,
                                          fromRestore: true);
                                    },
                                    backgroundColor: ColorHelper.primaryColor),
                                FocusedMenuItem(
                                    trailingIcon: const Icon(
                                        Icons.delete_forever,
                                        color: ColorHelper.whiteColor),
                                    title: const Text(
                                      'Delete from cloud',
                                      style: TextStyle(
                                          color: ColorHelper.whiteColor),
                                    ),
                                    onPressed: () async {
                                      notesController
                                          .deleteNoteFromCloud(noteData);
                                    },
                                    backgroundColor: ColorHelper.redAccentColor)
                              ],
                              child: Builder(builder: (context) {
                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: ColorHelper.blackColor
                                                .withOpacity(0.3)),
                                        color: ColorHelper.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        AutoSizeText(
                                          noteData.title,
                                          minFontSize: 16,
                                          maxLines: 4,
                                          textAlign: TextAlign.left,
                                          style: GoogleFonts.roboto(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        noteData.encrypted
                                            ? const Text("Note is encrypted ")
                                            : ShaderMask(
                                                shaderCallback: ((bounds) {
                                                  return const LinearGradient(
                                                      begin: Alignment.center,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        ColorHelper.blackColor,
                                                        ColorHelper.blackColor,
                                                        Colors.transparent
                                                      ]).createShader(bounds);
                                                }),
                                                child:
                                                    shaderMaskChild(noteData),
                                              ),
                                        Row(
                                          children: [
                                            Text(
                                              DateFormat('MMM d').format(noteData.date),
                                               
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12,
                                                    color: ColorHelper
                                                        .blackColor)),
                                            const Spacer(),
                                            SizedBox(
                                              width: 85,
                                              child: Text(noteData.folder,
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: true,
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 12,
                                                      color: ColorHelper
                                                          .blackColor)),
                                            ),
                                            noteData.isPinned == true
                                                ? const Icon(
                                                    Icons.push_pin,
                                                    size: 16,
                                                  )
                                                : const SizedBox.shrink(),
                                          ],
                                        )
                                      ],
                                    ));
                              }),
                            );
                          })),
                    ),
                  ],
                );
        }),
      ),
    );
  }

  shaderMaskChild(NoteModel noteData) {
    var json = jsonDecode(noteData.document);

    final controller = quill.QuillController(
        document: quill.Document.fromJson(json),
        selection: const TextSelection.collapsed(offset: 0));

    return quill.QuillEditor.basic(
      configurations: quill.QuillEditorConfigurations(
        embedBuilders: [
          ...(isWeb()
              ? FlutterQuillEmbeds.editorWebBuilders()
              : FlutterQuillEmbeds.editorBuilders(
                  imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
                    imageErrorWidgetBuilder: (context, error, stackTrace) {
                      return Text(
                        'Error while loading an image: ${error.toString()}',
                      );
                    },
                    imageProviderBuilder: (context, imageUrl) {
                      // cached_network_image is supported
                      // only for Android, iOS and web

                      // We will use it only if image from network
                      if (isAndroid(supportWeb: false) ||
                          isIOS(supportWeb: false) ||
                          isWeb()) {
                        if (isHttpBasedUrl(imageUrl)) {
                          return CachedNetworkImageProvider(
                            imageUrl,
                          );
                        }
                      }
                      return getImageProviderByImageSource(
                        imageUrl,
                        imageProviderBuilder: null,
                        context: context,
                        assetsPrefix: QuillSharedExtensionsConfigurations.get(
                                context: context)
                            .assetsPrefix,
                      );
                    },
                  ),
                )),
          TimeStampEmbedBuilderWidget(),
        ],
        controller: controller,
        padding: const EdgeInsets.only(bottom: 10),
        autoFocus: true,
        enableInteractiveSelection: false,
        // readOnly: true,
        showCursor: false,
        scrollPhysics: const NeverScrollableScrollPhysics(),
        scrollable: true,
        expands: false,
        maxHeight: 150,
      ),
      scrollController: ScrollController(keepScrollOffset: false),
      focusNode: FocusNode(),
    );
  }
}
