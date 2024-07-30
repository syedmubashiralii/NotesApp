import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/widgets/note_header.dart';
import 'package:notes_final_version/app/modules/notes/widgets/quill/my_quill_editor.dart';
import 'package:notes_final_version/app/modules/notes/widgets/quill/my_quill_toolbar.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:quill_pdf_converter/quill_pdf_converter.dart';
import 'package:uuid/uuid.dart';

import '../models/note_plaintext_model.dart';

class CreateNote extends StatelessWidget {
  CreateNote({super.key, this.updateNote, this.folderName, this.labelName});

  NoteModel? updateNote;
  String? folderName;
  String? labelName;
  final NotesController notesController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorHelper.primaryDarkColor,
      child: SafeArea(
          child: Scaffold(
        backgroundColor: ColorHelper.primaryDarkColor,
        body: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            SliverFillRemaining(
                child: Column(
              children: [
                AppBar(
                  backgroundColor: ColorHelper.primaryDarkColor,
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back)),
                  actions: [
                    IconButton(
                        onPressed: () async {
                          final pdfDocument = pw.Document();
                          final pdfWidgets = await notesController
                              .quillController.document
                              .toDelta()
                              .toPdf();
                          pdfDocument.addPage(
                            pw.MultiPage(
                              maxPages: 200,
                              pageFormat: PdfPageFormat.a4,
                              build: (context) {
                                return pdfWidgets;
                              },
                            ),
                          );
                          await Printing.layoutPdf(
                              onLayout: (format) async => pdfDocument.save());
                        },
                        icon: const Icon(
                          Icons.print,
                          color: Colors.black,
                        )),
                    IconButton(
                        onPressed: () async {
                          String? json = jsonEncode(notesController
                              .quillController.document
                              .toDelta()
                              .toJson());

                          String plainText = jsonEncode(notesController
                              .quillController.document
                              .toPlainText());

                          if (updateNote != null) {
                            if (updateNote!.encrypted) {
                              NotePlaintextModel? encText =
                                  await notesController.encryptNoteBeforeSaving(
                                      json, plainText);
                              if (encText != null) {
                                json = encText.note;
                                plainText = encText.plaintext;
                              }
                            }
                          }

                          final String uid = const Uuid().v4();
                          NoteModel note = NoteModel(
                            document: json,
                            searchableDocument: plainText,
                            title: notesController.titleController.text,
                            isArchived: updateNote != null
                                ? updateNote!.isArchived
                                : false,
                            isPinned: updateNote != null
                                ? updateNote!.isPinned
                                : false,
                            folder: notesController.selectedFolder.value,
                            date: DateTime.now(),
                            uid: updateNote != null ? updateNote!.uid : uid,
                            labels: notesController.labels.value,
                            edited: true,
                            encrypted: updateNote != null
                                ? updateNote!.encrypted
                                : false,
                          );
                          notesController.addUpdateNote(note,
                              folderName: folderName, labelName: labelName);
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.save,
                          color: Colors.black,
                        )),
                  ],
                ),
                NoteHeader(
                  editNoteMod: false,
                  titleController: notesController.titleController,
                  selected: notesController.selectedFolder,
                ),

                Builder(
                  builder: (context) {
                    return Expanded(
                      child: MyQuillEditor(
                        configurations: QuillEditorConfigurations(
                          sharedConfigurations:
                              HelperFunction.sharedConfigurations,
                          controller: notesController.quillController,
                          // readOnly: false,
                        ),
                        scrollController:
                            notesController.editorScrollController.value,
                        focusNode: notesController.editorFocusNode.value,
                      ),
                    );
                  },
                ),
                MyQuillToolbar(
                  controller: notesController.quillController,
                  focusNode: notesController.editorFocusNode.value,
                ),
                // Expanded(
                //   child: editor.QuillEditor(
                //     configurations: editor.QuillEditorConfigurations(
                //       controller: notesController.quillController,
                //       expands: true,
                //       readOnly: false,
                //       scrollable: true,
                //       autoFocus: false,
                //       padding: const EdgeInsets.symmetric(horizontal: 20),
                //     ),
                //     focusNode: FocusNode(),
                //     scrollController: ScrollController(),
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 12.0),
                //   child: editor.QuillToolbar.simple(
                //     configurations: editor.QuillSimpleToolbarConfigurations(
                //       controller: notesController.quillController,
                //       multiRowsDisplay: true,
                //       toolbarSize: 40,
                //       fontFamilyValues: {
                //         'Amatic': GoogleFonts.amaticSc().fontFamily!,
                //         'Annie': GoogleFonts.annieUseYourTelescope().fontFamily!,
                //         'Formal': GoogleFonts.petitFormalScript().fontFamily!,
                //         'Roboto': GoogleFonts.roboto().fontFamily!
                //       },
                //       fontSizesValues: const {
                //         '14': '14.0',
                //         '16': '16.0',
                //         '18': '18.0',
                //         '20': '20.0',
                //         '22': '22.0',
                //         '24': '24.0',
                //         '26': '26.0',
                //         '28': '28.0',
                //         '30': '30.0',
                //         '35': '35.0',
                //         '40': '40.0'
                //       },
                //       showIndent: true,
                //       dialogTheme: const editor.QuillDialogTheme(
                //           inputTextStyle: TextStyle(color: Colors.white),
                //           labelTextStyle: TextStyle(color: Colors.white)),
                //       showLink: true,
                //       showDirection: false,
                //       showBackgroundColorButton: false,
                //       showRedo: true,
                //       showSearchButton: true,
                //       showFontSize: true,
                //       showAlignmentButtons: true,
                //       showCodeBlock: true,
                //       showFontFamily: false,
                //       showInlineCode: false,
                //     ),
                //   ),
                // ),
              ],
            ))
          ],
        ),
        // floatingActionButton: Container(
        //   color: ColorHelper.primaryColor,
        //   child: BlocBuilder<SettingsCubit, SettingsState>(
        //       buildWhen: (previous, current) =>
        //           previous.useCustomQuillToolbar != current.useCustomQuillToolbar,
        //       builder: (myContext, state) {
        //         return QuillToolbarImageButton(
        //           controller: notesController.quillController,
        //           options: const QuillToolbarImageButtonOptions(),
        //         );
        //       }),
        // ),
      )),
    );
  }
}
