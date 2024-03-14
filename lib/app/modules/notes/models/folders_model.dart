import 'package:hive/hive.dart';

part 'folders_model.g.dart';

@HiveType(typeId: 2)
class FolderModel {
  @HiveField(0)
  final String uid;
  @HiveField(1)
  String name;
  @HiveField(2)
  final DateTime date;

  FolderModel({required this.uid, required this.name, required this.date});

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'date': date};
  }

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      uid: json['uid'],
      name: json['name'],
      date: DateTime.parse(json['date']),
    );
  }
}
