import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone_updated_gradle/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationController {
  FlutterLocalNotificationsPlugin localNotification =
      FlutterLocalNotificationsPlugin();

  initializeNotification() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSinitialize = const DarwinInitializationSettings();
    var initilizationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSinitialize);
    localNotification.initialize(
      initilizationsSettings,
      onDidReceiveNotificationResponse: (details) {
        notificationSelected(details.payload ?? "");
      },
    );
  }

  Future sceduleNotification(
      DateTime scheduledTime, int id, String body, String payload) async {
    var androidDetails = const AndroidNotificationDetails("1", "Kp Notes",
        channelDescription: "KpNotesNotificationChannel",
        importance: Importance.max);
    var generalNotificationDetails = NotificationDetails(
        android: androidDetails, iOS: const DarwinNotificationDetails());
    // The device's timezone.
    String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    // Find the 'current location'
    final location = tz.getLocation(timeZoneName);

    final st = tz.TZDateTime.from(scheduledTime, location);
    log(st.toString());
    localNotification.zonedSchedule(
        id, "Kp Notes", body, st, generalNotificationDetails,
        androidAllowWhileIdle: true,
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> scheduleDailyNotification(
      int id, tz.TZDateTime scheduledDate) async {
    await localNotification.zonedSchedule(
        id,
        'Daily Notification',
        'Daily Reminder',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            '1',
            'Daily Reminder',
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  Future<void> scheduleWeeklyNotification(
      int id, tz.TZDateTime scheduledDate) async {
    await localNotification.zonedSchedule(
        id,
        'Weekly Notification',
        'Weekly Reminder',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails('1', 'Weekly notification'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: navigator!.context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  tz.TZDateTime nextInstanceOf(DateTime now) {
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 12);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future cancelNotification(int id) async {
    await localNotification.cancel(id);
  }

  Future cancelAllNotifications() async {
    await localNotification.cancelAll();
  }
}
