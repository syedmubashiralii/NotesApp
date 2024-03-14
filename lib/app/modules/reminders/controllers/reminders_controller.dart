import 'package:flutter/material.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_final_version/app/modules/reminders/controllers/notification_controller.dart';
import 'package:notes_final_version/app/modules/reminders/models/reminder_model.dart';

class RemindersController extends GetxController {
  //TODO: Implement RemindersController

  final reminderBox = Hive.box<ReminderModel>('reminders');
  RxList<ReminderModel?> remindersList = <ReminderModel>[].obs;
  late NotificationController notificationController;
  String? timeZoneName;
  DateTime? date;
  TimeOfDay? time;

  Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  getMinute(t) {
    if (t.minute < 10) {
      return "0${t.minute}";
    } else {
      return t.minute;
    }
  }

  getAmPm(t) {
    if (t.period.toString() == "DayPeriod.am") {
      return "am";
    } else {
      return "pm";
    }
  }

  List<ReminderModel?> getAllReminders() {
    final remindersList = reminderBox.keys
        .map((key) {
          final value = reminderBox.get(key);
          return value;
        })
        .where((element) => element != null)
        .toList();

    return remindersList;
  }

  void addUpdateReminder(ReminderModel newReminder) async {
    bool found = false;
    bool foundName = false;
    int index = 0;

    List<ReminderModel?> reminderData = reminderBox.keys.map((key) {
      final value = reminderBox.get(key);
      return value;
    }).toList();

    if (reminderData.isNotEmpty) {
      for (int i = 0; i < reminderData.length; i++) {
        if (reminderData[i]!.uid.toString() == newReminder.uid) {
          found = true;
          index = i;
        }
      }
    }

    if (found == false) {
      await addReminder(newReminder);
    } else {
      await updateReminder(index, newReminder);
    }
  }

  Future<void> addReminder(ReminderModel newItem) async {
    await reminderBox.add(newItem); // add note
    remindersList.value = getAllReminders()
        .where((reminder) => reminder != null)
        .cast<ReminderModel>()
        .toList();

    remindersList.refresh();
  }

  Future<void> updateReminder(int index, ReminderModel updateItem) async {
    await reminderBox.putAt(index, updateItem); // update note

    remindersList.value = getAllReminders()
        .where((reminder) => reminder != null)
        .cast<ReminderModel>()
        .toList();

    remindersList.refresh();
  }

  // delele todo
  Future<void> deleteReminder(String uid) async {
    List<ReminderModel?> reminderData = reminderBox.keys.map((key) {
      final value = reminderBox.get(key);
      return value;
    }).toList();

    if (reminderData.isNotEmpty) {
      for (int i = 0; i < reminderData.length; i++) {
        if (reminderData[i]!.uid.toString() == uid) {
          await reminderBox.deleteAt(i);
          remindersList.value = getAllReminders()
              .where((todo) => todo != null)
              .cast<ReminderModel>()
              .toList();
          remindersList.refresh();
          return;
        }
      }
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    notificationController = NotificationController();
    timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    notificationController.initializeNotification();
    date = DateTime.now();
    time = TimeOfDay.now();
  }
}
