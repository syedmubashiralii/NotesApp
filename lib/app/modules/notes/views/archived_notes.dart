import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/embeds/widgets/image.dart';
import 'package:flutter_quill_extensions/flutter_quill_embeds.dart';
import 'package:flutter_quill_extensions/models/config/image/editor/image_configurations.dart';
import 'package:flutter_quill_extensions/models/config/shared_configurations.dart';
import 'package:flutter_quill_extensions/utils/utils.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jiffy/jiffy.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/views/create_note.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/constants.dart';

import '../widgets/quill/embeds/timestamp_embed.dart';

class ArchivedNotes extends StatelessWidget {
  ArchivedNotes({super.key});

  final NotesController notesController = Get.find();

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
        title: Text("Archive Notes",
            style: GoogleFonts.poppins(fontSize: AppConstants.kAppbarFontSize)),
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.kScreenPadding),
        child: Obx(() {
          return MasonryGridView.builder(
              physics: const BouncingScrollPhysics(),
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              itemCount: notesController.archivedNotesList.length,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
              itemBuilder: ((gridViewContext, index) {
                NoteModel? noteData = notesController.archivedNotesList[index];
                // var json = jsonDecode(noteData!.document);
                // final controller = quill.QuillController(
                //     document: quill.Document.fromJson(json),
                //     selection: const TextSelection.collapsed(offset: 0));

                if (noteData == null) {
                  return const Text("Note is null");
                }
                return FocusedMenuHolder(
                  menuWidth: 200,
                  menuOffset: 10,
                  bottomOffsetHeight: 0,
                  menuBoxDecoration:
                      const BoxDecoration(color: ColorHelper.blackColor),
                  animateMenuItems: false,
                  blurBackgroundColor: ColorHelper.blackColor,
                  onPressed: () {
                    navigateToNoteEditScreen(noteData);
                  },
                  menuItems: menuList(noteData, json),
                  child: Builder(builder: (context) {
                    return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 22,
                        ),
                        decoration: BoxDecoration(
                            color: ColorHelper.primaryColor,
                            borderRadius: BorderRadius.circular(25)),
                        child: Column(
                          children: [
                            AutoSizeText(
                              noteData.title,
                              minFontSize: 16,
                              maxLines: 4,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.roboto(
                                  fontSize: 10, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            noteData.encrypted
                                ? Text("Note is encrypted")
                                : ShaderMask(
                                    shaderCallback: ((bounds) {
                                      return const LinearGradient(
                                          begin: Alignment.center,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            ColorHelper.blackColor,
                                            ColorHelper.blackColor,
                                            Colors.transparent
                                          ]).createShader(bounds);
                                    }),
                                    child: shaderMaskChild(noteData),

                                    // quill.QuillEditor(
                                    //   configurations: quill.QuillEditorConfigurations(
                                    //     controller: controller,
                                    //     padding: const EdgeInsets.only(bottom: 10),
                                    //     autoFocus: true,
                                    //     enableInteractiveSelection: false,
                                    //     readOnly: true,
                                    //     showCursor: false,
                                    //     scrollPhysics:
                                    //         const NeverScrollableScrollPhysics(),
                                    //     scrollable: true,
                                    //     expands: false,
                                    //     maxHeight: 150,
                                    //   ),
                                    //   scrollController:
                                    //       ScrollController(keepScrollOffset: false),
                                    //   focusNode: FocusNode(),
                                    // ),
                                  ),
                            Row(
                              children: [
                                Text(
                                    Jiffy(DateTime.parse(
                                            noteData.date.toString()))
                                        .MMMd
                                        .toString(),
                                    style: GoogleFonts.roboto(
                                        fontSize: 12,
                                        color: ColorHelper.blackColor)),
                                const Spacer(),
                                SizedBox(
                                  width: 85,
                                  child: Text(noteData.folder,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      softWrap: true,
                                      style: GoogleFonts.roboto(
                                          fontSize: 12,
                                          color: ColorHelper.blackColor)),
                                )
                              ],
                            )
                          ],
                        ));
                  }),
                );
              }));
        }),
      ),
    );
  }

  List<FocusedMenuItem> menuList(noteData, json) {
    return [
      FocusedMenuItem(
          trailingIcon: const Icon(Icons.edit, color: ColorHelper.blackColor),
          title: const Text(
            'Edit',
            style: TextStyle(color: ColorHelper.blackColor),
          ),
          onPressed: () {
            navigateToNoteEditScreen(noteData);
          },
          backgroundColor: ColorHelper.primaryColor),
      FocusedMenuItem(
          trailingIcon:
              const Icon(Icons.archive, color: ColorHelper.blackColor),
          title: Text(
            noteData.isArchived == false ? 'Archive' : 'Unarchive',
            style: const TextStyle(color: ColorHelper.blackColor),
          ),
          onPressed: () async {
            noteData.isArchived = !noteData.isArchived;
            notesController.addUpdateNote(noteData);
          },
          backgroundColor: ColorHelper.primaryColor),
      FocusedMenuItem(
          trailingIcon:
              const Icon(Icons.push_pin, color: ColorHelper.blackColor),
          title: Text(
            noteData.encrypted ? 'Decrypt' : 'Encrypt',
            style: const TextStyle(color: ColorHelper.blackColor),
          ),
          onPressed: () async {
            if (noteData.encrypted) {
              notesController.performDecryption(
                  noteData: noteData, updateNoteInstance: true);
            } else {
              // permanently encrypt
              notesController.performEncryption(
                noteData,
              );
            }
          },
          backgroundColor: ColorHelper.primaryColor),
      FocusedMenuItem(
          trailingIcon: const Icon(Icons.delete_forever_outlined,
              color: ColorHelper.whiteColor),
          title: const Text(
            'Delete',
            style: TextStyle(color: ColorHelper.whiteColor),
          ),
          onPressed: () async {
            notesController.deleteNote(noteData.uid);
          },
          backgroundColor: ColorHelper.redAccentColor)
    ];
  }

  encryptedNoteBuild(NoteModel noteData) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: ColorHelper.primaryColor),
      child: Column(
        children: [
          const Text("Note is encrypted"),
          ElevatedButton(onPressed: () {}, child: Text("View")),
        ],
      ),
    );
  }

  shaderMaskChild(NoteModel noteData) {
    if (noteData.encrypted) {
      return encryptedNoteBuild(noteData);
    }
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
        readOnly: true,
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

  navigateToNoteEditScreen(NoteModel noteData) async {
    // todo decrypt before moving
    String? decryptedData = noteData.document;
    if (noteData.encrypted) {
      decryptedData =
          await notesController.performDecryption(noteData: noteData);
      if (decryptedData == null) {
        // DefaultSnackbar.show('Trouble', "Unable to open note.");
        return;
      }
    }

    var json = jsonDecode(decryptedData);

    // notesController.quillController.document = quill.Document.fromJson(json);
    // notesController.titleController.text = noteData.title;
    // notesController.selectedFolder.value = noteData.folder;
    // notesController.labels.value = noteData.labels;
    // Get.to(CreateNote(
    //     updateNote: noteData, folderName: folderName, labelName: labelName));

    notesController.quillController.document = quill.Document.fromJson(json);
    notesController.titleController.text = noteData.title;
    notesController.selectedFolder.value = noteData.folder;
    notesController.labels.value = noteData.labels;
    Get.to(CreateNote(
      updateNote: noteData,
    ));
  }
}
