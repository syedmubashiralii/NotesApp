import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_final_version/app/modules/notes/models/labels_model.dart';

class LabelsController extends GetxController {
  //label list
  RxList<LabelModel?> labelsList = <LabelModel>[].obs;

  TextEditingController titleController = TextEditingController();
  final labelsBox = Hive.box<LabelModel>('labels');

  //
  void addUpdateLabel(LabelModel newLabel) async {
    bool found = false;
    bool foundName = false;
    int index = 0;

    List<LabelModel?> labelsData = labelsBox.keys.map((key) {
      final value = labelsBox.get(key);
      return value;
    }).toList();

    if (labelsData.isNotEmpty) {
      for (int i = 0; i < labelsData.length; i++) {
        if (labelsData[i]!.uid.toString() == newLabel.uid) {
          found = true;
          index = i;
        }
        if (labelsData[i]!.name.toString() == newLabel.name) {
          foundName = true;
        }
      }
    }
    print("found$foundName");
    if (foundName == false) {
      if (found == false) {
        await addLabel(newLabel);
      } else {
        await updateLabel(index, newLabel);
      }
      return;
    } else {
      // DefaultSnackbar.show("Trouble", "Label already exsist");
    }
  }

  List<LabelModel?> getAllLabels() {
    final labelsList = labelsBox.keys
        .map((key) {
          final value = labelsBox.get(key);
          return value;
        })
        .where((element) => element != null)
        .toList();

    return labelsList;
  }

  Future<void> addLabel(LabelModel newItem) async {
    await labelsBox.add(newItem); // add note
    labelsList.value = getAllLabels()
        .where((label) => label != null)
        .cast<LabelModel>()
        .toList();
  }

  Future<void> updateLabel(int index, LabelModel updateItem) async {
    await labelsBox.putAt(index, updateItem); // update note

    labelsList.value = getAllLabels()
        .where((label) => label != null)
        .cast<LabelModel>()
        .toList();
  }

  // Delete a single item
  Future<void> deleteLabel(String uid) async {
    List<LabelModel?> labelsData = labelsBox.keys.map((key) {
      final value = labelsBox.get(key);
      return value;
    }).toList();

    if (labelsData.isNotEmpty) {
      for (int i = 0; i < labelsData.length; i++) {
        if (labelsData[i]!.uid.toString() == uid) {
          await labelsBox.deleteAt(i);
          labelsList.value = getAllLabels()
              .where((label) => label != null)
              .cast<LabelModel>()
              .toList();
          labelsList.refresh();
          return;
        }
      }
    }
  }

  @override
  void onReady() {
    labelsList.value = getAllLabels()
        .where((note) => note != null)
        .cast<LabelModel>()
        .toList();

    super.onReady();
  }
}
