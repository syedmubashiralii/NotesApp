import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as editor;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:notes_final_version/app/modules/notes/models/notes_model.dart';

class NotesController extends GetxController {
  RxList<NoteModel?> notesList = <NoteModel>[].obs;
  RxList<NoteModel?> searchedNotesList = <NoteModel>[].obs;
  RxList<NoteModel?> archivedNotesList = <NoteModel>[].obs;
  RxList<NoteModel?> pinnedNotesList = <NoteModel>[].obs;
  RxList<String> labels = <String>[].obs;
  final box = GetStorage();
  final editorFocusNode = FocusNode().obs;
  final editorScrollController = ScrollController().obs;

  final editor.QuillController quillController = editor.QuillController.basic();
  final TextEditingController titleController = TextEditingController();
  Rx<TextEditingController> searchController = TextEditingController().obs;
  ValueNotifier<String> selectedFolder = ValueNotifier('Notes');
  RxString appLanguage = 'EN'.obs;

  RxBool showFolders = true.obs;

  RxString selectedFilter = 'Title'.obs;

  final notesBox = Hive.box<NoteModel>('notes');

  final zoomDrawerController = ZoomDrawerController();

  void toggleDrawer() {
    zoomDrawerController.toggle?.call();
    update();
  }

  void addUpdateNote(NoteModel newNote,
      {String? folderName, String? labelName}) async {
    bool found = false;
    int index = 0;

    List<NoteModel?> notesData = notesBox.keys.map((key) {
      final value = notesBox.get(key);
      return value;
    }).toList();

    if (notesData.isNotEmpty) {
      for (int i = 0; i < notesData.length; i++) {
        if (notesData[i]!.uid.toString() == newNote.uid) {
          found = true;
          index = i;
        }
      }
    }
    if (found == false) {
      await addNote(newNote, folderName: folderName, labelName: labelName);
    } else {
      await updateNote(index, newNote,
          folderName: folderName, labelName: labelName);
    }
  }

  List<NoteModel?> getAllNotes({String? folderName, String? labelName}) {
    final notesList = notesBox.keys
        .map((key) {
          final value = notesBox.get(key);
          return value;
        })
        .where((element) => element!.isArchived == false)
        .toList();

    // Sort the list with pinned notes on top
    notesList.sort((a, b) {
      if (a!.isPinned && !b!.isPinned) {
        return -1; // 'a' comes before 'b'
      } else if (!a.isPinned && b!.isPinned) {
        return 1; // 'b' comes before 'a'
      } else {
        return 0; // No change in order
      }
    });
    if (folderName != null) {
      return notesList
          .where((element) =>
              element!.folder.toLowerCase() == folderName.toLowerCase())
          .toList();
    }
    if (labelName != null) {
      return notesList
          .where((element) => element!.labels.contains(labelName))
          .toList();
    }
    return notesList;
  }

  List<NoteModel?> getArchivedNotes() {
    final notesList = notesBox.keys
        .map((key) {
          final value = notesBox.get(key);
          return value;
        })
        .where((element) => element!.isArchived == true)
        .toList();

    return notesList;
  }

  List<NoteModel?> getPinnedNotes() {
    final notesList = notesBox.keys
        .map((key) {
          final value = notesBox.get(key);
          return value;
        })
        .where((element) => element!.isPinned == true)
        .toList();

    return notesList;
  }

  Future<void> addNote(NoteModel newItem,
      {String? folderName, String? labelName}) async {
    await notesBox.add(newItem);

    notesList.value = getAllNotes(folderName: folderName, labelName: labelName)
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    archivedNotesList.value = getArchivedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
  }

  Future<void> updateNote(int index, NoteModel updateItem,
      {String? folderName, String? labelName}) async {
    await notesBox.putAt(index, updateItem);

    notesList.value = getAllNotes(folderName: folderName, labelName: labelName)
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    archivedNotesList.value = getArchivedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
  }

  void searchNotes(String value) {
    if (selectedFilter.value == "Title") {
      searchedNotesList.value = notesList.value
          .where(
              (note) => note!.title.toLowerCase().contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    } else if (selectedFilter.value == "Folder") {
      searchedNotesList.value = notesList.value
          .where((note) =>
              note!.folder.toLowerCase().contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    } else if (selectedFilter.value == "Label") {
      searchedNotesList.value = notesList.value
          .where((note) => note!.labels.contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    } else {
      searchedNotesList.value = notesList.value
          .where((note) => note!.searchableDocument
              .toLowerCase()
              .contains(value.toLowerCase()))
          .cast<NoteModel>()
          .toList();
    }
  }

  // Delete a single item
  Future<void> deleteNote(String uid,
      {String? folderName, String? labelName}) async {
    List<NoteModel?> notesData = notesBox.keys.map((key) {
      final value = notesBox.get(key);
      return value;
    }).toList();

    if (notesData.isNotEmpty) {
      for (int i = 0; i < notesData.length; i++) {
        if (notesData[i]!.uid.toString() == uid) {
          await notesBox.deleteAt(i);
          notesList.value =
              getAllNotes(folderName: folderName, labelName: labelName)
                  .where((note) => note != null)
                  .cast<NoteModel>()
                  .toList();
          notesList.refresh();
          return;
        }
      }
    }
  }

  // Retrieve a single item from the database by using its key
  NoteModel? readItem(int key) {
    final item = notesBox.get(key);
    return item;
  }

  @override
  void onReady() {
    notesList.value =
        getAllNotes().where((note) => note != null).cast<NoteModel>().toList();
    archivedNotesList.value = getArchivedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    pinnedNotesList.value = getPinnedNotes()
        .where((note) => note != null)
        .cast<NoteModel>()
        .toList();
    showFolders.value = box.read("showFolders") ?? true;
    box.listenKey('showFolders', (value) {
      if (value == false) {
        notesList.value = getAllNotes()
            .where((note) => note != null)
            .cast<NoteModel>()
            .toList();
      }
    });
    super.onReady();
  }

  @override
  void dispose() {
    quillController.dispose();
    titleController.dispose();
    searchController.value.dispose();
    super.dispose();
  }
}
