import 'dart:io' as io show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/extensions.dart' show isAndroid, isIOS, isWeb;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

import 'cubit/settings_cubit.dart';
import 'embeds/timestamp_embed.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    // required this.myContext,
    required this.focusNode,
    super.key,
  });

  final QuillController controller;
  final FocusNode focusNode;

  // final BuildContext myContext;

  Future<void> onImageInsertWithCropping(
    String image,
    QuillController controller,
    BuildContext context,
  ) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: image,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    final newImage = croppedFile?.path;
    if (newImage == null) {
      return;
    }
    if (isWeb()) {
      controller.insertImageBlock(imageSource: newImage);
      return;
    }
    final newSavedImage = await saveImage(io.File(newImage));
    controller.insertImageBlock(imageSource: newSavedImage);
  }

  Future<void> onImageInsert(String image, QuillController controller) async {
    if (isWeb() || isHttpBasedUrl(image)) {
      controller.insertImageBlock(imageSource: image);
      return;
    }
    final newSavedImage = await saveImage(io.File(image));
    controller.insertImageBlock(imageSource: newSavedImage);
  }

  /// For mobile platforms it will copies the picked file from temporary cache
  /// to applications directory
  ///
  /// for desktop platforms, it will do the same but from user files this time
  Future<String> saveImage(io.File file) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final fileExt = path.extension(file.path);
    final newFileName = '${DateTime.now().toIso8601String()}$fileExt';
    final newPath = path.join(
      appDocDir.path,
      newFileName,
    );
    final copiedFile = await file.copy(newPath);
    return copiedFile.path;
  }

  @override
  Widget build(BuildContext myContext) {
    myContext.read<SettingsCubit>().updateSettings(
        const SettingsState().copyWith(useCustomQuillToolbar: true));

    return Container(
      color: ColorHelper.primaryColor,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.useCustomQuillToolbar != current.useCustomQuillToolbar,
        builder: (myContext, state) {
          if (state.useCustomQuillToolbar) {
            return QuillToolbar(
              configurations: const QuillToolbarConfigurations(),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Wrap(
                  children: [
                    IconButton(
                      onPressed: () => myContext
                          .read<SettingsCubit>()
                          .updateSettings(
                              state.copyWith(useCustomQuillToolbar: false)),
                      icon: const Icon(
                        Icons.expand,
                      ),
                    ),
                    QuillToolbarHistoryButton(
                      isUndo: true,
                      controller: controller,
                    ),
                    //  QuillToolbarImageButton(
                    //   controller: controller,
                    // ),
                    // QuillToolbarCameraButton(
                    //   controller: controller,
                    // ),
                    QuillToolbarHistoryButton(
                      isUndo: false,
                      controller: controller,
                    ),
                    QuillToolbarToggleStyleButton(
                      options: const QuillToolbarToggleStyleButtonOptions(),
                      controller: controller,
                      attribute: Attribute.bold,
                    ),
                    QuillToolbarToggleStyleButton(
                      options: const QuillToolbarToggleStyleButtonOptions(),
                      controller: controller,
                      attribute: Attribute.italic,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.underline,
                    ),
                    QuillToolbarClearFormatButton(
                      controller: controller,
                    ),
                    // const VerticalDivider(),
                   
                    // QuillToolbarVideoButton(
                    //   controller: controller,
                    // ),
                    // const VerticalDivider(),
                    QuillToolbarColorButton(
                      controller: controller,
                      isBackground: false,
                    ),
                    QuillToolbarColorButton(
                      controller: controller,
                      isBackground: true,
                    ),
                    // const VerticalDivider(),
                    QuillToolbarSelectHeaderStyleDropdownButton(
                      controller: controller,
                    ),
                    // const VerticalDivider(),
                    QuillToolbarToggleCheckListButton(
                      controller: controller,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.ol,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.ul,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.inlineCode,
                    ),
                    QuillToolbarToggleStyleButton(
                      controller: controller,
                      attribute: Attribute.blockQuote,
                    ),
                    QuillToolbarIndentButton(
                      controller: controller,
                      isIncrease: true,
                    ),
                    QuillToolbarIndentButton(
                      controller: controller,
                      isIncrease: false,
                    ),
                    // const VerticalDivider(),
                    QuillToolbarLinkStyleButton(controller: controller),
                  ],
                ),
              ),
            );
          }
          return QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: controller,
              showAlignmentButtons: true,
              multiRowsDisplay: true,
              fontFamilyValues: {
                'Amatic': GoogleFonts.amaticSc().fontFamily!,
                'Annie': GoogleFonts.annieUseYourTelescope().fontFamily!,
                'Formal': GoogleFonts.petitFormalScript().fontFamily!,
                'Roboto': GoogleFonts.roboto().fontFamily!
              },
              fontSizesValues: const {
                '14': '14.0',
                '16': '16.0',
                '18': '18.0',
                '20': '20.0',
                '22': '22.0',
                '24': '24.0',
                '26': '26.0',
                '28': '28.0',
                '30': '30.0',
                '35': '35.0',
                '40': '40.0'
              },
              // headerStyleType: HeaderStyleType.buttons,
              // buttonOptions: QuillSimpleToolbarButtonOptions(
              //   base: QuillToolbarBaseButtonOptions(
              //     afterButtonPressed: focusNode.requestFocus,
              //     // iconSize: 20,
              //     iconTheme: QuillIconTheme(
              //       iconButtonSelectedData: IconButtonData(
              //         style: IconButton.styleFrom(
              //           foregroundColor: Colors.blue,
              //         ),
              //       ),
              //       iconButtonUnselectedData: IconButtonData(
              //         style: IconButton.styleFrom(
              //           foregroundColor: Colors.red,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              customButtons: [
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.add_alarm_rounded),
                  onPressed: () {
                    controller.document
                        .insert(controller.selection.extentOffset, '\n');
                    controller.updateSelection(
                      TextSelection.collapsed(
                        offset: controller.selection.extentOffset + 1,
                      ),
                      ChangeSource.local,
                    );

                    controller.document.insert(
                      controller.selection.extentOffset,
                      TimeStampEmbed(
                        DateTime.now().toString(),
                      ),
                    );

                    controller.updateSelection(
                      TextSelection.collapsed(
                        offset: controller.selection.extentOffset + 1,
                      ),
                      ChangeSource.local,
                    );

                    controller.document
                        .insert(controller.selection.extentOffset, ' ');
                    controller.updateSelection(
                      TextSelection.collapsed(
                        offset: controller.selection.extentOffset + 1,
                      ),
                      ChangeSource.local,
                    );

                    controller.document
                        .insert(controller.selection.extentOffset, '\n');
                    controller.updateSelection(
                      TextSelection.collapsed(
                        offset: controller.selection.extentOffset + 1,
                      ),
                      ChangeSource.local,
                    );
                  },
                ),
                QuillToolbarCustomButtonOptions(
                  icon: const Icon(Icons.dashboard_customize),
                  onPressed: () {
                    myContext.read<SettingsCubit>().updateSettings(
                        state.copyWith(useCustomQuillToolbar: true));
                  },
                ),
              ],
              embedButtons: FlutterQuillEmbeds.toolbarButtons(
                imageButtonOptions: QuillToolbarImageButtonOptions(
                  iconSize: 70,
                  imageButtonConfigurations: QuillToolbarImageConfigurations(
                    onImageInsertCallback: isAndroid(supportWeb: false) ||
                            isIOS(supportWeb: false) ||
                            isWeb()
                        ? (image, controller) => onImageInsertWithCropping(
                            image, controller, myContext)
                        : onImageInsert,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
