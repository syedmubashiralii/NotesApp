// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:notes_final_version/app/modules/notes/widgets/quill/cubit/settings_cubit.dart';
import 'package:notes_final_version/app/modules/reminders/controllers/reminders_controller.dart';
import 'package:notes_final_version/app/modules/reminders/models/reminder_model.dart';
import 'package:notes_final_version/app/modules/reminders/models/timeOfDayAdaptar.dart';
import 'package:notes_final_version/app/modules/todos/controllers/todo_controller.dart';
import 'package:notes_final_version/app/modules/todos/models/todo_model.dart';
import 'package:notes_final_version/app/routes/app_pages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await GetStorage.init();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );
  await Hive.initFlutter();
  Hive.registerAdapter(TimeOfDayAdapter());
  Hive.registerAdapter(NoteModelAdapter());
  await Hive.openBox<NoteModel>('notes');
  Hive.registerAdapter(LabelModelAdapter());
  await Hive.openBox<LabelModel>('labels');
  Hive.registerAdapter(FolderModelAdapter());
  await Hive.openBox<FolderModel>('folders');
  Hive.registerAdapter(TodoModelAdapter());
  await Hive.openBox<TodoModel>('todos');
  Hive.registerAdapter(ReminderModelAdapter());
  await Hive.openBox<ReminderModel>('reminders');
  NotesController notesController = Get.put(NotesController(), permanent: true);
  LabelsController labelsController = Get.put(LabelsController(), permanent: true);
  FoldersController foldersController = Get.put(FoldersController(), permanent: true);
  TodoController todoController = Get.put(TodoController(), permanent: true);
  RemindersController remindersController = Get.put(RemindersController(), permanent: true);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingsCubit(),
        )
      ],
      child: GetMaterialApp(
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(textScaler: TextScaler.linear(data.textScaleFactor > 1.3 ? 1.3 : 1.0)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: "KP Notes",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
