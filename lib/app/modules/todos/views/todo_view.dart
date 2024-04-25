import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/todos/widgets/todo_tile.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';
import 'package:notes_final_version/app/utils/helper_functions.dart';

import '../controllers/todo_controller.dart';

// binding means
class TodoView extends GetView<TodoController> {
  const TodoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorHelper.primaryDarkColor,
      appBar: AppBar(
        title: const Text('TO DO'),
        backgroundColor: ColorHelper.primaryDarkColor,
        elevation: 0,
      ),
      floatingActionButton: const FloatingActionButton(
        onPressed: HelperFunction.showAddTodoSheet,
        child: Icon(Icons.add),
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: controller.todosList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              index: index,
              // taskName: todo!.name,
              // taskCompleted: todo.completed,
              // onChanged: (value) {
              //   todo.completed = value!;
              //   controller.addUpdateTodo(todo);
              // },
              // deleteFunction: (context) => controller.deleteTodo(todo.uid),
            );
          },
        );
      }),
    );
  }
}
