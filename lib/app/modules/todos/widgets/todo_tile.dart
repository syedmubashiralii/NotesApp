import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:notes_final_version/app/modules/todos/controllers/todo_controller.dart';
import 'package:notes_final_version/app/utils/color_helper.dart';

class ToDoTile extends StatelessWidget {
  // final String taskName;
  // final bool taskCompleted;
  // Function(bool?)? onChanged;
  // Function(BuildContext)? deleteFunction;

  int index;

  ToDoTile(
      {super.key,
      // required this.taskName,
      // required this.taskCompleted,
      // required this.onChanged,
      // required this.deleteFunction,
      required this.index});

  final TodoController todoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      var todo = todoController.todosList[index];
      return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => todoController.deleteTodo(todo!.uid),
                icon: Icons.delete,
                backgroundColor: ColorHelper.redAccentColor,
                borderRadius: BorderRadius.circular(12),
              )
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: ColorHelper.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // checkbox
                Checkbox(
                  value: todo!.completed,
                  onChanged: (value) {
                    todo.completed = value!;

                    todoController.addUpdateTodo(todo);

                    setState(() {});
                  },
                  activeColor: Colors.black,
                ),

                // task name
                Text(
                  todo.name,
                  style: TextStyle(
                    decoration: todo.completed
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
