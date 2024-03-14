import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:notes_final_version/app/modules/todos/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoController extends GetxController {
  //TODO: Implement TodoController

  final todoNameController = TextEditingController();
  final todosBox = Hive.box<TodoModel>('todos');
  RxList<TodoModel?> todosList = <TodoModel>[].obs;

  List<TodoModel?> getAllTodos() {
    final foldersList = todosBox.keys
        .map((key) {
          final value = todosBox.get(key);
          return value;
        })
        .where((element) => element != null)
        .toList();

    return foldersList;
  }

  void addUpdateTodo(TodoModel newTodo) async {
    bool found = false;
    bool foundName = false;
    int index = 0;

    List<TodoModel?> todoData = todosBox.keys.map((key) {
      final value = todosBox.get(key);
      return value;
    }).toList();

    if (todoData.isNotEmpty) {
      for (int i = 0; i < todoData.length; i++) {
        if (todoData[i]!.uid.toString() == newTodo.uid) {
          found = true;
          index = i;
        }
      }
      for (int i = 0; i < todoData.length; i++) {
        if (todoData[i]!.name.toString() == newTodo.name) {
          foundName = true;
        }
      }
    }
    if (foundName == false) {
      if (found == false) {
        await addTodo(newTodo);
      } else {
        await updateTodo(index, newTodo);
      }
    } else {
      //DefaultSnackbar.show("Trouble", "Todo already exsist");
    }
  }

  Future<void> addTodo(TodoModel newItem) async {
    await todosBox.add(newItem); // add note
    todosList.value =
        getAllTodos().where((todo) => todo != null).cast<TodoModel>().toList();

    todosList.refresh();
  }

  Future<void> updateTodo(int index, TodoModel updateItem) async {
    await todosBox.putAt(index, updateItem); // update note

    todosList.value =
        getAllTodos().where((todo) => todo != null).cast<TodoModel>().toList();

    todosList.refresh();
  }

  // delele todo
  Future<void> deleteTodo(String uid) async {
    List<TodoModel?> todoData = todosBox.keys.map((key) {
      final value = todosBox.get(key);
      return value;
    }).toList();

    if (todoData.isNotEmpty) {
      for (int i = 0; i < todoData.length; i++) {
        if (todoData[i]!.uid.toString() == uid) {
          await todosBox.deleteAt(i);
          todosList.value = getAllTodos()
              .where((todo) => todo != null)
              .cast<TodoModel>()
              .toList();
          todosList.refresh();
          return;
        }
      }
    }
  }

  @override
  void onReady() {
    todosList.value =
        getAllTodos().where((note) => note != null).cast<TodoModel>().toList();

    if (todosList.isEmpty && kDebugMode) {
      final String uid = const Uuid().v4();
      addTodo(TodoModel(
          uid: uid,
          name: "Do Exercise",
          completed: false,
          date: DateTime.now()));
    }

    super.onReady();
  }
}
