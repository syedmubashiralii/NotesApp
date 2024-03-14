import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_final_version/app/modules/reminders/models/timeOfDayAdaptar.dart';

part 'reminder_model.g.dart';

@HiveType(typeId: 4)
class ReminderModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  String reminderDescription;
  @HiveField(2)
  String reminderID;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  bool isExpanded;
  @HiveField(5)
  String expandedValue;
  @HiveField(6)
  String headerValue;
  @HiveField(7)
  bool daily;
  @HiveField(8)
  bool weekly;
  @HiveField(9)
  bool toggle;
  @HiveField(10)
  int did;
  @HiveField(11)
  int wid;
  @HiveField(12)
  TimeOfDay time;

  ReminderModel(
      {required this.uid,
      required this.reminderDescription,
      required this.reminderID,
      required this.date,
      required this.daily,
      required this.did,
      required this.weekly,
      required this.wid,
      required this.expandedValue,
      required this.isExpanded,
      required this.headerValue,
      required this.toggle,
      required this.time});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'reminderDescription': reminderDescription,
      'reminderID': reminderID,
      'date': date,
      'daily': daily,
      'did': did,
      'weekly': weekly,
      'wid': wid,
      'expandedValue': expandedValue,
      'isExpanded': isExpanded,
      'headerValue': headerValue,
      'toggle': toggle,
      'time': time
    };
  }

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
        uid: json['uid'],
        reminderDescription: json['reminderDescription'],
        reminderID: json['reminderID'],
        date: DateTime.parse(json['date']),
        daily: json['daily'],
        did: json['did'],
        weekly: json['weekly'],
        wid: json['wid'],
        expandedValue: json['expandedValue'],
        isExpanded: json['isExpanded'],
        headerValue: json['headerValue'],
        toggle: json['toggle'],
        time: json['time']);
  }
}
