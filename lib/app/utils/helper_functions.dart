import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/models/config/shared_configurations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
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

import '../modules/auth/controllers/auth_controller.dart';
import '../modules/auth/models/user_model.dart';
import '../modules/auth/services/encryptor_controller/encryptor_controller.dart';
import '../modules/notes/widgets/input_master_password_widget.dart';
import '../modules/reminders/models/timeOfDayAdaptar.dart';
import 'utils.dart';

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

  static giveDelay({int milliseconds = 200, int? seconds}) async {
    if (seconds != null) {
      await Future.delayed(Duration(seconds: seconds));
    } else {
      await Future.delayed(Duration(milliseconds: milliseconds));
    }
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

  static Future<bool?> showMasterPasswordInputSheet(UserModel userModel) async {
    return await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        isScrollControlled: true,
        context: navigator!.context,
        builder: (context) {
          return InputMasterPasswordBottomSheet(userModel: userModel);
        });
  }

  static Future<bool?> showMasterPasswordRecoverySheet(
      UserModel userModel) async {
    return await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        isScrollControlled: true,
        context: navigator!.context,
        builder: (context) {
          return MasterPasswordRecoveryBottomSheet(userModel: userModel);
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

  static Future<void> mainInitializer() async {
    await _registerHiveBoxes();
    _registerController();
  }

  static Future<void> _registerHiveBoxes() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TimeOfDayAdapter());
    Hive.registerAdapter(NoteModelAdapter());

    final key = [
      205,
      187,
      255,
      103,
      132,
      197,
      31,
      148,
      96,
      63,
      186,
      210,
      37,
      192,
      31,
      108,
      24,
      170,
      117,
      87,
      122,
      15,
      60,
      129,
      230,
      42,
      5,
      252,
      35,
      22,
      9,
      91
    ]; //Hive.generateSecureKey();

    // final encryptedBox= await Hive.openBox('vaultBox', encryptionCipher: HiveAesCipher(key));
    logInfo("key: $key");

    await Hive.openBox<NoteModel>(
      'notes',
      // encryptionCipher: HiveAesCipher(key),
    );
    Hive.registerAdapter(LabelModelAdapter());
    await Hive.openBox<LabelModel>('labels');
    Hive.registerAdapter(FolderModelAdapter());
    await Hive.openBox<FolderModel>('folders');
    Hive.registerAdapter(TodoModelAdapter());
    await Hive.openBox<TodoModel>('todos');
    Hive.registerAdapter(ReminderModelAdapter());
    await Hive.openBox<ReminderModel>('reminders');
  }

  static void _registerController() {
    Get.put(AuthController(), permanent: true);
    Get.put(EncryptionController(), permanent: true);

    NotesController notesController =
        Get.put(NotesController(), permanent: true);
    LabelsController labelsController =
        Get.put(LabelsController(), permanent: true);
    FoldersController foldersController =
        Get.put(FoldersController(), permanent: true);
    TodoController todoController = Get.put(TodoController(), permanent: true);
    RemindersController remindersController =
        Get.put(RemindersController(), permanent: true);

//   auth controllers
  }
}
