import 'package:hive/hive.dart';

part 'labels_model.g.dart';

@HiveType(typeId: 1)
class LabelModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  final DateTime date;

  LabelModel({required this.uid, required this.name, required this.date});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'date': date};
  }

  factory LabelModel.fromJson(Map<String, dynamic> json) {
    return LabelModel(
      uid: json['uid'],
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }
}
