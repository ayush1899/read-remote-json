import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class Todo {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todo(this.userId, this.id, this.title, this.completed);
}

class RemoteJson extends StatefulWidget {
  @override
  _RemoteJsonState createState() => _RemoteJsonState();
}

class _RemoteJsonState extends State<RemoteJson> {
  Future<List<Todo>> _getTodo() async {
    var todoData = await http.get("jsonplaceholder.typicode.com/todos");
    var jsonData = json.decode(todoData.body);
    List<Todo> todos = [];
    for (var tod in jsonData) {
      Todo todo = Todo(tod["userId"], tod["id"], tod["title"], tod["completed"]);
      todos.add(todo);
    }
    return todos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Read Remote Json"),
      ),
      body: Container(
        child: FutureBuilder(
            future: _getTodo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Waiting..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].title),
                      subtitle: Text(snapshot.data[index].completed),
                    );
                  },
                );
              }
            }),
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: RemoteJson(),
    );
  }
}
