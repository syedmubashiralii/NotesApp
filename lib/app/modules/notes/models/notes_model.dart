import 'package:hive/hive.dart';

part 'notes_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  String document;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String folder;
  @HiveField(3)
  final DateTime date;
  @HiveField(4)
  final String uid;
  @HiveField(5)
  bool isArchived;
  @HiveField(6)
  bool isPinned;
  @HiveField(7)
  String searchableDocument;
  @HiveField(8)
  List<String> labels;
  @HiveField(9)
  bool encrypted;
  @HiveField(10)
  bool edited;

  NoteModel(
      {required this.document,
      required this.searchableDocument,
      required this.title,
      required this.isArchived,
      required this.isPinned,
      required this.folder,
      required this.date,
      required this.uid,
      required this.labels,
      this.edited = false,
      this.encrypted = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'folder': folder,
      'isPinned': isPinned,
      'isArchived': isArchived,
      'date': date.toIso8601String(),
      'uid': uid,
      'document': document,
      'searchableDocument': searchableDocument,
      'labels': labels,
      'edited': edited,
      'encrypted': encrypted,
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      document: json['document'],
      searchableDocument: json['searchableDocument'],
      title: json['title'],
      isArchived: json['isArchived'],
      isPinned: json['isPinned'],
      folder: json['folder'],
      date: DateTime.parse(json['date']),
      uid: json['uid'],
      labels: json['labels'],
      edited: json.containsKey('edited') ? json['edited'] : false,
      encrypted: json.containsKey('encrypted') ? json['encrypted'] : false,
    );
  }
}
