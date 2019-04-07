import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Page/index.dart';
import 'package:flutter_assignment_02/Page/add_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDoList_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        "/": (context) => Index(),
        "/addtodo" : (context) => Add()
      },
    );
  }
}