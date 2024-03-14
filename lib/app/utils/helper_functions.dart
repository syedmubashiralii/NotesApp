import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/models/config/shared_configurations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes_final_version/app/modules/notes/controllers/folders_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/labels_controller.dart';
import 'package:notes_final_version/app/modules/notes/controllers/notes_controller.dart';
import 'package:notes_final_version/app/modules/notes/models/folders_model.dart';
import 'package:notes_final_version/app/modules/notes/models/labels_model.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';
import 'package:notes_final_version/app/modules/notes/widgets/add_folder_widget.dart';
import 'package:notes_final_version/app/modules/notes/widgets/add_label_widget.dart';
import 'package:notes_final_version/app/modules/notes/widgets/filter_sheet.dart';
import 'package:notes_final_version/app/modules/reminders/controllers/reminders_controller.dart';
import 'package:notes_final_version/app/modules/reminders/models/reminder_model.dart';
import 'package:notes_final_version/app/modules/todos/controllers/todo_controller.dart';
import 'package:notes_final_version/app/modules/todos/models/todo_model.dart';
import 'package:notes_final_version/app/modules/todos/widgets/add_todo_widget.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

class HelperFunction {
  // static void closeKeyboard(BuildContext context) {
  //   FocusScopeNode currentFocus = FocusScope.of(context);
  //   if (!currentFocus.hasPrimaryFocus) {
  //     currentFocus.unfocus();
  //   }
  // }

 static DateTime getOnlyDate(DateTime dateTime) {
    DateTime localDateTime = dateTime.toLocal();
    return DateTime(localDateTime.year, localDateTime.month, localDateTime.day);
  }


  static Future showFiltersSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        context: navigator!.context,
        builder: (context) {
          return FilterBottomSheet();
        });
  }

  static Future showAddFolderSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        isScrollControlled: true,
        context: navigator!.context,
        builder: (context) {
          return AddFolderBottomSheet();
        });
  }

  static Future showAddTodoSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        isScrollControlled: true,
        context: navigator!.context,
        builder: (context) {
          return AddTodoBottomSheet();
        });
  }

  static Future addLabelSheet() {
    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        isScrollControlled: true,
        context: navigator!.context,
        builder: (context) {
          return AddLabelBottomSheet();
        });
  }

  static Future<void> openColorPicker() async {
    NotesController notesController = Get.find();
    Color? color = ColorHelper.primaryColor;

    bool pickedColor = await ColorPicker(
      color: color,
      onColorChanged: (Color newColor) {
        print(newColor);

        ColorHelper.primaryColor = newColor;
      },
      width: 40,
      height: 40,
      borderRadius: 20,
      spacing: 10,
      runSpacing: 10,
      heading: const Text('Pick primary color'),
      subheading: const Text('Select primary color shade'),
      wheelDiameter: 200,
      wheelWidth: 20,
    ).showPickerDialog(navigator!.context);
  }

  static QuillSharedConfigurations get sharedConfigurations {
    return const QuillSharedConfigurations(
      // locale: Locale('en'),
      extraConfigurations: {
        QuillSharedExtensionsConfigurations.key:
            QuillSharedExtensionsConfigurations(
          assetsPrefix: 'assets', // Defaults to assets
        ),
      },
    );
  }

  static mainInitializer() async {
    
  }
}
