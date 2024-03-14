import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_final_version/app/modules/notes/models/folders_model.dart';
import 'package:notes_final_version/app/utils/widgets/default_snackbar.dart';
import 'package:uuid/uuid.dart';

class FoldersController extends GetxController {
  //label list
  RxList<FolderModel?> foldersList = <FolderModel>[].obs;
  TextEditingController titleController = TextEditingController();

  final folderBox = Hive.box<FolderModel>('folders');

  //
  void addUpdateFolder(FolderModel newFolder) async {
    bool found = false;
    bool foundName = false;
    int index = 0;

    List<FolderModel?> foldersData = folderBox.keys.map((key) {
      final value = folderBox.get(key);
      return value;
    }).toList();

    if (foldersData.isNotEmpty) {
      for (int i = 0; i < foldersData.length; i++) {
        if (foldersData[i]!.uid.toString() == newFolder.uid) {
          found = true;
          index = i;
        }
      }
      for (int i = 0; i < foldersData.length; i++) {
        if (foldersData[i]!.name.toString() == newFolder.name) {
          foundName = true;
        }
      }
    }
    if (foundName == false) {
      if (found == false) {
        await addFolder(newFolder);
      } else {
        await updateFolder(index, newFolder);
      }
    } else {
      DefaultSnackbar.show("Trouble", "Folder already exsist");
    }
  }

  List<FolderModel?> getAllFolders() {
    final foldersList = folderBox.keys
        .map((key) {
          final value = folderBox.get(key);
          return value;
        })
        .where((element) => element != null)
        .toList();

    return foldersList;
  }

  Future<void> addFolder(FolderModel newItem) async {
    await folderBox.add(newItem); // add note
    foldersList.value = getAllFolders()
        .where((label) => label != null)
        .cast<FolderModel>()
        .toList();
  }

  Future<void> updateFolder(int index, FolderModel updateItem) async {
    await folderBox.putAt(index, updateItem); // update note

    foldersList.value = getAllFolders()
        .where((label) => label != null)
        .cast<FolderModel>()
        .toList();
  }

  // Delete a single item
  Future<void> deleteFolder(String uid) async {
    List<FolderModel?> foldersData = folderBox.keys.map((key) {
      final value = folderBox.get(key);
      return value;
    }).toList();

    if (foldersData.isNotEmpty) {
      for (int i = 0; i < foldersData.length; i++) {
        if (foldersData[i]!.uid.toString() == uid) {
          await folderBox.deleteAt(i);
          foldersList.value = getAllFolders()
              .where((label) => label != null)
              .cast<FolderModel>()
              .toList();
          foldersList.refresh();
          return;
        }
      }
    }
  }

  @override
  void onReady() {
    foldersList.value = getAllFolders()
        .where((note) => note != null)
        .cast<FolderModel>()
        .toList();

    if (foldersList.isEmpty) {
      final String uid = const Uuid().v4();
      addFolder(FolderModel(uid: uid, name: "Notes", date: DateTime.now()));
    }

    super.onReady();
  }
}
