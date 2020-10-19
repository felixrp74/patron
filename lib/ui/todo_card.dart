import 'package:flutter/material.dart';
import 'package:patron/controllers/controllers.dart';
import 'package:patron/models/todo_model.dart';
// import 'package:todo_app/models/todo.dart';
// import 'package:todo_app/services/database.dart';

class TodoCard extends StatelessWidget {
  // final String uid;
  final TodoModel todo;

  const TodoCard({Key key, this.todo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                todo.content,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Checkbox(
              value: todo.done,
              onChanged: (newValue) {
                print("solo quiero checkbox");
                TodoController().updateTodo(newValue, todo.todoId); 
              },
            ),
          ],
        ),
      ),
    );
  }
}
