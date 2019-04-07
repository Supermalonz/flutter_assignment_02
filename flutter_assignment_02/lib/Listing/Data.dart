import 'dart:async';
import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "_id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo {
  int id;
  String title;
  bool done;

  Todo();
  Todo.formMap(Map<String, dynamic> map) {
    this.id = map[columnId];
    this.title = map[columnTitle];
    this.done = map[columnDone] == 1;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      columnTitle: title,
      columnDone: done == true ? 1 : 0
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class TodoProvider {
  Database db;

  Future open(String path) async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
      create table $tableTodo (
        $columnId integer primary key autoincrement,
        $columnTitle text not null,
        $columnDone integer not null
      )
      ''');
    });
  }
  Future delete(int id) async {
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }
  Future<Todo> insert(Todo todo) async {
    await this.open("todo.db");
    db.insert(tableTodo, todo.toMap());
    return todo;
  }
  Future<Todo> getTodo(int id) async {
    List<Map<String, dynamic>> map = await db.query(tableTodo,
        columns: [columnId, columnTitle, columnDone],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (map.length > 0) {
      return new Todo.formMap(map.first);
    }
    return null;
  }
  Future<List<Todo>> getAll() async {
    await this.open("todo.db");
    var map = await db.query(tableTodo);
    List<Todo> list = map.isNotEmpty ? map.map((c) => Todo.formMap(c)).toList() : [];
    return list;
  }
  Future<int> update(Todo todo) async {
    return await db.update(tableTodo, todo.toMap(),
        where: "$columnId = ?", whereArgs: [todo.id]);
  }
  Future close() async => db.close();
}