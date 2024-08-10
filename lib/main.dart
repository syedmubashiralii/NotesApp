// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/translations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notes_final_version/app/modules/notes/widgets/quill/cubit/settings_cubit.dart';
import 'package:notes_final_version/app/routes/app_pages.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';
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

  await HelperFunction.mainInitializer();

  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (context) => SettingsCubit())],
      child: GetMaterialApp(
        builder: (BuildContext context, Widget? child) {
          final MediaQueryData data = MediaQuery.of(context);
          return MediaQuery(
            data: data.copyWith(
                textScaler:
                    TextScaler.linear(data.textScaleFactor > 1.3 ? 1.3 : 1.0)),
            child: child!,
          );
        },
        localizationsDelegates: const [
          FlutterQuillLocalizations.delegate, 
        ],
        supportedLocales: const [
          Locale('en', 'US'),
        ],
        debugShowCheckedModeBanner: false,
        title: "KP Notes",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    ),
  );
}
