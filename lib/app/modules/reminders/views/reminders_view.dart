import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:notes_final_version/app/modules/reminders/controllers/reminders_controller.dart';
import 'package:notes_final_version/app/modules/reminders/models/reminder_model.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:uuid/uuid.dart';

class RemindersView extends StatefulWidget {
  const RemindersView({Key? key}) : super(key: key);
  @override
  RemindersViewState createState() => RemindersViewState();
}

class RemindersViewState extends State<RemindersView> {
  RemindersController remindersController = Get.find();
  DateTime scheduleTime = DateTime.now();
  // List alarms = [];
  // int counter = 0;
  // List<ReminderItem> reminders = [];
  String? reminder;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reminder'), actions: [
        IconButton(
            icon: const Icon(CupertinoIcons.delete),
            onPressed: () async {
              remindersController.notificationController
                  .cancelAllNotifications();

              ///clear all reminders
            })
      ]),
      body: Obx(() {
        return ListView(
          children: <Widget>[
            ExpansionPanelList(
              expansionCallback: (int index, bool isExpanded) {
                remindersController.remindersList[index]!.isExpanded =
                    !remindersController.remindersList[index]!.isExpanded;
                remindersController.addUpdateReminder(
                    remindersController.remindersList[index]!);
              },
              children: remindersController.remindersList
                      .map<ExpansionPanel>((ReminderModel? item) {
                    int index = remindersController.remindersList.indexOf(item);
                    return ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder: (context, isExpanded) {
                          return Row(children: [
                            Expanded(
                                child: ListTile(
                              title: Text(item.headerValue ?? ""),
                            )),
                            // IconButton(icon: Icon(Icons.edit), onPressed: null),
                            Switch(
                              value: item.toggle,
                              onChanged: (value) {
                                setState(() {
                                  item.toggle = !item.toggle;
                                  remindersController.addUpdateReminder(item);
                                  if (!value) {
                                    remindersController.notificationController
                                        .cancelNotification(
                                            int.parse(item.reminderID));
                                  }
                                  if (value) {
                                    remindersController.notificationController
                                        .sceduleNotification(
                                            item.date,
                                            int.parse(item.reminderID),
                                            item.reminderDescription ?? "",
                                            '${DateFormat('yyyy-MM-dd').format(item.date)} at ${item.time.hourOfPeriod}:${remindersController.getMinute(item.time)} ${remindersController.getAmPm(item.time)}');
                                  }
                                });
                              },
                            )
                          ]);
                        },
                        body: Column(children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ListTile(
                                    title: Text(
                                  item!.expandedValue ?? "",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15.0,
                                  ),
                                )),
                              ),
                              IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                  ),
                                  color: ColorHelper.primaryDarkColor,
                                  onPressed: () {
                                    // editReminder(reminders.indexOf(item));
                                  }),
                              IconButton(
                                  color: ColorHelper.primaryDarkColor,
                                  icon: const Icon(
                                    Icons.event,
                                  ),
                                  onPressed: () {
                                    // editDate(context, reminders.indexOf(item));
                                  }),
                              IconButton(
                                  color: ColorHelper.primaryDarkColor,
                                  icon: const Icon(
                                    Icons.access_time,
                                  ),
                                  onPressed: () {
                                    // editTime(context, reminders.indexOf(item));
                                  }),
                              IconButton(
                                icon: const Icon(CupertinoIcons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  remindersController.notificationController
                                      .cancelNotification(
                                          int.parse(item.reminderID));

                                  remindersController.deleteReminder(item.uid);
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          2.0, 0.0, 0.0, 20.0),
                                      child: Column(children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.alarm,
                                            color: item.daily == true
                                                ? Colors.green
                                                : Colors.black,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (item.daily == true) {
                                                remindersController
                                                    .notificationController
                                                    .cancelNotification(
                                                        item.did);
                                                item.daily = false;
                                                remindersController
                                                    .addUpdateReminder(item);
                                              } else {
                                                item.did = remindersController
                                                        .remindersList.length +
                                                    5;
                                                item.daily = true;
                                                remindersController
                                                    .addUpdateReminder(item);
                                                remindersController
                                                    .notificationController
                                                    .scheduleDailyNotification(
                                                        item.did,
                                                        remindersController
                                                            .notificationController
                                                            .nextInstanceOf(
                                                                item.date));
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          'Daily ',
                                          style: GoogleFonts.poppins(),
                                        )
                                      ]))),
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          2.0, 0.0, 0.0, 20.0),
                                      child: Column(children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.alarm,
                                            color: item.weekly == true
                                                ? Colors.green
                                                : Colors.black,
                                          ),
                                          onPressed: () {
                                            if (item.weekly == true) {
                                              remindersController
                                                  .notificationController
                                                  .cancelNotification(item.wid);
                                              item.weekly = false;
                                              remindersController
                                                  .addUpdateReminder(item);
                                            } else {
                                              item.wid = remindersController
                                                      .remindersList.length +
                                                  7;
                                              item.weekly = true;
                                              remindersController
                                                  .addUpdateReminder(item);
                                              remindersController
                                                  .notificationController
                                                  .scheduleWeeklyNotification(
                                                      item.wid,
                                                      remindersController
                                                          .notificationController
                                                          .nextInstanceOf(
                                                              item.date));
                                            }
                                          },
                                        ),
                                        Text(
                                          'Weekly',
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ]))),
                            ],
                          )
                        ]),
                        isExpanded: item.isExpanded ?? true);
                  }).toList() ??
                  [],
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          remindersController.date = DateTime.now();
          remindersController.time = TimeOfDay.now();
          DatePicker.showDateTimePicker(
            context,
            showTitleActions: true,
            minTime: DateTime.now().add(const Duration(minutes: 2)),
            onChanged: (date) {
              scheduleTime = date;
              // String formattedDate =
              //     DateFormat('yyyy-MM-dd').format(scheduleTime);
              // String formattedTime = DateFormat.Hm().format(scheduleTime);
              remindersController.time = TimeOfDay.fromDateTime(scheduleTime);
              remindersController.date = scheduleTime;
            },
            onConfirm: (date) {
              scheduleTime = date;
              // String formattedDate =
              //     DateFormat('yyyy-MM-dd').format(scheduleTime);
              // String formattedTime = DateFormat.Hm().format(scheduleTime);
              remindersController.time = TimeOfDay.fromDateTime(scheduleTime);
              remindersController.date = scheduleTime;
              final String uid = const Uuid().v4();
              String reminderDescription = "Testing";
              int reminderID = remindersController.remindersList.length + 2;
              remindersController.addUpdateReminder(ReminderModel(
                  uid: uid,
                  reminderDescription: reminderDescription,
                  reminderID: (reminderID).toString(),
                  date: date,
                  daily: false,
                  did: 0,
                  weekly: false,
                  wid: 0,
                  expandedValue:
                      '${DateFormat('yyyy-MM-dd').format(date)} at ${remindersController.time!.hourOfPeriod}:${remindersController.getMinute(remindersController.time)} ${remindersController.getAmPm(remindersController.time)}',
                  isExpanded: false,
                  headerValue: reminderDescription,
                  toggle: true,
                  time: remindersController.time!));
              log(date.toString());
              remindersController.notificationController.sceduleNotification(
                  date,
                  reminderID,
                  reminderDescription ?? "",
                  '${DateFormat('yyyy-MM-dd').format(date)} at ${remindersController.time!.hourOfPeriod}:${remindersController.getMinute(remindersController.time)} ${remindersController.getAmPm(remindersController.time)}');
            },
          );
          // pickDate(context, null);
        },
        tooltip: 'Add',
        child: const Icon(Icons.event),
      ),
    );
  }

  // Future picktime(BuildContext context, int? index) async {
  //   log("enter$index");
  //   TimeOfDay tod = TimeOfDay.now();
  //   TimeOfDay? t = await showTimePicker(
  //     context: context,
  //     initialTime: (index != null)
  //         ? alarms[index][1]
  //         : TimeOfDay(
  //             hour: tod.hour,
  //             minute: (tod.minute == 59) ? tod.minute : tod.minute + 1),
  //   );
  //   int l = alarms.length;
  //   remindersController.time = t;
  //   index = l;
  //   DateTime? st;
  //   st = remindersController.date!
  //       .add(Duration(hours: t!.hour, minutes: t.minute, seconds: 5));

  //   await setReminder();
  //   if (st.isAfter(DateTime.now())) {
  //     alarms[index][2] = remindersController.date!
  //         .add(Duration(hours: t.hour, minutes: t.minute, seconds: 5));
  //     var id = index;
  //     remindersController.notificationController.sceduleNotification(
  //         alarms[index][2],
  //         index,
  //         alarms[id ?? alarms.length][4],
  //         counter,
  //         '${alarms[id ?? alarms.length][4]} at ${alarms[id ?? alarms.length][1].hourOfPeriod}:${remindersController.getMinute(alarms[id ?? alarms.length][1])} ${remindersController.getAmPm(alarms[id ?? alarms.length][1])}');
  //     final location = tz.getLocation(remindersController.timeZoneName ?? "");

  //     final st = tz.TZDateTime.from(alarms[index][2], location);
  //     setState(() {
  //       alarms[index ?? alarms.length][2] = st;
  //       alarms[index ?? alarms.length][3] = counter;
  //       counter = counter + 1;
  //     });
  //     alarms.insert(l, [
  //       remindersController.date,
  //       remindersController.time,
  //       false,
  //       counter,
  //       reminder
  //     ]);
  //     reminder = null;
  //     reminders = generateItems(alarms);
  //   }
  //   setState(() {});
  // }

  // Future pickDate(BuildContext context, int? index) async {
  //   DateTime? date = await showDatePicker(
  //     context: context,
  //     initialDate: (index != null) ? alarms[index][0] : DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2030),
  //   );
  //   setState(() {
  //     remindersController.date = date;
  //   });
  //   picktime(context, index);
  // }

  // setReminder() async {
  //   await showDialog(
  //     context: context,
  //     builder: (context) => SimpleDialog(children: [
  //       Container(
  //           padding: const EdgeInsets.all(10.0),
  //           child: Form(
  //               key: _formKey,
  //               child: Column(
  //                 children: [
  //                   TextFormField(
  //                     autovalidateMode: AutovalidateMode.disabled,
  //                     validator: (value) => (value == "")
  //                         ? "Please Enter Reminder Details"
  //                         : null,
  //                     onSaved: (input) => reminder = input,
  //                     decoration: InputDecoration(
  //                         labelText: 'Enter Reminder Details',
  //                         contentPadding: const EdgeInsets.symmetric(
  //                             horizontal: 10.0, vertical: 10.0),
  //                         border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10.0))),
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       ElevatedButton(
  //                           onPressed: () {
  //                             if (_formKey.currentState!.validate()) {
  //                               _formKey.currentState!.save();
  //                               Navigator.pop(context, reminder);
  //                             }
  //                           },
  //                           child: const Text('Submit'))
  //                     ],
  //                   )
  //                 ],
  //               ))),
  //     ]),
  //   );
  // }

  // editDate(BuildContext context, int index) async {
  //   DateTime? newDate = await showDatePicker(
  //     context: context,
  //     initialDate: index != null ? alarms[index][0] : DateTime.now(),
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //   );
  //   List newdateTime = [newDate, alarms[index][1], false];
  //   if (newdateTime[0] != alarms[index][0] ||
  //       newdateTime[1] != alarms[index][1]) {
  //     DateTime nst = remindersController.date!.add(Duration(
  //         hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
  //     await remindersController.notificationController.localNotification
  //         .cancel(alarms[index][3]);
  //     var id = index;
  //     remindersController.notificationController.sceduleNotification(
  //         alarms[index][2],
  //         index,
  //         alarms[id ?? alarms.length][4],
  //         counter,
  //         '${alarms[id ?? alarms.length][4]} at ${alarms[id ?? alarms.length][1].hourOfPeriod}:${remindersController.getMinute(alarms[id ?? alarms.length][1])} ${remindersController.getAmPm(alarms[id ?? alarms.length][1])}');
  //     final location = tz.getLocation(remindersController.timeZoneName ?? "");

  //     final st = tz.TZDateTime.from(alarms[index][2], location);
  //     setState(() {
  //       alarms[index ?? alarms.length][2] = st;
  //       alarms[index ?? alarms.length][3] = counter;
  //       counter = counter + 1;
  //     });
  //     setState(() {
  //       alarms[index][0] = newdateTime[0];
  //       alarms[index][1] = newdateTime[1];
  //       reminders = generateItems(alarms);
  //     });
  //   }
  // }

  // editTime(BuildContext context, int index) async {
  //   TimeOfDay? newtime = await showTimePicker(
  //     context: context,
  //     initialTime: alarms[index][1],
  //   );
  //   List newdateTime = [alarms[index][0], newtime, false];

  //   if (newdateTime[0] != alarms[index][0] ||
  //       newdateTime[1] != alarms[index][1]) {
  //     DateTime nst = newdateTime[0]
  //         .add(Duration(hours: newtime!.hour, minutes: newtime.minute));
  //     await remindersController.notificationController.localNotification
  //         .cancel(alarms[index][3]);
  //     var id = index;
  //     remindersController.notificationController.sceduleNotification(
  //         alarms[index][2],
  //         index,
  //         alarms[id ?? alarms.length][4],
  //         counter,
  //         '${alarms[id ?? alarms.length][4]} at ${alarms[id ?? alarms.length][1].hourOfPeriod}:${remindersController.getMinute(alarms[id ?? alarms.length][1])} ${remindersController.getAmPm(alarms[id ?? alarms.length][1])}');
  //     final location = tz.getLocation(remindersController.timeZoneName ?? "");

  //     final st = tz.TZDateTime.from(alarms[index][2], location);
  //     setState(() {
  //       alarms[index ?? alarms.length][2] = st;
  //       alarms[index ?? alarms.length][3] = counter;
  //       counter = counter + 1;
  //     });
  //     setState(() {
  //       alarms[index][0] = newdateTime[0];
  //       alarms[index][1] = newdateTime[1];
  //       reminders = generateItems(alarms);
  //     });
  //   }
  // }

  // editAlarm(BuildContext context, int index) async {
  //   DateTime? newDate = await showDatePicker(
  //     context: context,
  //     initialDate: alarms[index][0],
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(DateTime.now().year + 5),
  //   );
  //   TimeOfDay? newtime = await showTimePicker(
  //     context: context,
  //     initialTime: alarms[index][1],
  //   );
  //   List newdateTime = [newDate, newtime, false];

  //   if (newdateTime[0] != alarms[index][0] ||
  //       newdateTime[1] != alarms[index][1]) {
  //     DateTime nst = remindersController.date!
  //         .add(Duration(hours: newtime!.hour, minutes: newtime.minute));
  //     await remindersController.notificationController.localNotification
  //         .cancel(alarms[index][3]);
  //     var id = index;
  //     remindersController.notificationController.sceduleNotification(
  //         alarms[index][2],
  //         index,
  //         alarms[id ?? alarms.length][4],
  //         counter,
  //         '${alarms[id ?? alarms.length][4]} at ${alarms[id ?? alarms.length][1].hourOfPeriod}:${remindersController.getMinute(alarms[id ?? alarms.length][1])} ${remindersController.getAmPm(alarms[id ?? alarms.length][1])}');
  //     final location = tz.getLocation(remindersController.timeZoneName ?? "");

  //     final st = tz.TZDateTime.from(alarms[index][2], location);
  //     setState(() {
  //       alarms[index ?? alarms.length][2] = st;
  //       alarms[index ?? alarms.length][3] = counter;
  //       counter = counter + 1;
  //     });
  //     setState(() {
  //       alarms[index][0] = newdateTime[0];
  //       alarms[index][1] = newdateTime[1];
  //       reminders = generateItems(alarms);
  //     });
  //   }
  // }

  // editReminder(int index) async {
  //   await setReminder();
  //   setState(() {
  //     alarms[index][4] = reminder;
  //     DateTime dt = alarms[index][0].add(Duration(
  //         hours: alarms[index][1].hour, minutes: alarms[index][1].minute));
  //     remindersController.notificationController.localNotification
  //         .cancel(alarms[index][3]);
  //     var id = index;
  //     remindersController.notificationController.sceduleNotification(
  //         dt,
  //         index,
  //         alarms[id ?? alarms.length][4],
  //         counter,
  //         '${alarms[id ?? alarms.length][4]} at ${alarms[id ?? alarms.length][1].hourOfPeriod}:${remindersController.getMinute(alarms[id ?? alarms.length][1])} ${remindersController.getAmPm(alarms[id ?? alarms.length][1])}');
  //     final location = tz.getLocation(remindersController.timeZoneName ?? "");

  //     final st = tz.TZDateTime.from(alarms[index][2], location);
  //     setState(() {
  //       alarms[index ?? alarms.length][2] = st;
  //       alarms[index ?? alarms.length][3] = counter;
  //       counter = counter + 1;
  //     });
  //     reminders = generateItems(alarms);
  //   });
  // }
}

// List<ReminderItem> generateItems(List reminders) {
//   RemindersController remindersController = Get.find();
//   return List.generate(reminders.length, (int index) {
//     return ReminderItem(
//       id: reminders[index][3],
//       headerValue: '${reminders[index][4]}',
//       isExpanded: false,
//       expandedValue:
//           '${reminders[index][0].day} ${remindersController.monthsInYear[reminders[index][0].month]} ${reminders[index][0].year} , ${reminders[index][1].hourOfPeriod}:${remindersController.getMinute(reminders[index][1])} ${remindersController.getAmPm(reminders[index][1])}',
//     );
//   });
// }
