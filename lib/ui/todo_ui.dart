import 'package:flutter/material.dart';
import 'package:patron/localizations.dart';
import 'package:patron/controllers/controllers.dart';
import 'package:patron/models/todo_model.dart';
import 'package:patron/ui/components/components.dart';
import 'package:patron/ui/todo_card.dart';
import 'package:patron/ui/ui.dart';
import 'package:get/get.dart';

class TodoUI extends StatelessWidget {
  final TextEditingController _todoController = TextEditingController();
  TodoModel todo; 
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoController> (
      init: TodoController(),
      builder: (_) {
        print("----renderizaar");
        return Scaffold(
          appBar: AppBar(
            title: Text("TODO"),
          ),
          body: Column(children: <Widget>[
            Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _todoController,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_todoController.text != "") {
                        TodoController()
                            .addTodo(_todoController.text);
                        _todoController.clear();
                        // print(_todoController.text+"light it up");
                      }
                    },
                  )
                ],
              ),
            ),
          ),

          Text(
            "Tus Pedidos",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          GetX<TodoController>(
            init: Get.put<TodoController>(TodoController()),
            builder: (TodoController todoController) {
              if (todoController != null && todoController.todoStream() != null) {
                // print("======== ${todoController?.todos} ========");
                return Expanded( 
                  child: ListView.builder(
                    itemCount: todoController?.todos?.length,
                    itemBuilder: (_, index) {
                      return TodoCard(
                        // uid: controller.user.uid,
                        todo: todoController?.todos[index]);
                    },
                  ),
                );
              } else {
                return Text("loading...");
              }
            },
          )
          ],)
          

        );
      }   
      
    );
  }
}