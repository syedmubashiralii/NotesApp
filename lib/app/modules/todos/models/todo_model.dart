import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 3)
class TodoModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  bool completed;
  @HiveField(3)
  final DateTime date;

  TodoModel(
      {required this.uid,
      required this.name,
      required this.completed,
      required this.date});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'completed': completed, 'date': date};
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      uid: json['uid'],
      name: json['name'],
      completed: json['completed'],
      date: DateTime.parse(json['date']),
    );
  }
}
