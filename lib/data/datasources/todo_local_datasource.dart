import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDatasource {
  Future<List<TodoModel>> getTodos();
  Future<void> saveTodos(List<TodoModel> todos);
}

class TodoLocalDatasourceImpl implements TodoLocalDatasource {
  final SharedPreferences prefs;

  TodoLocalDatasourceImpl(this.prefs);

  final String key = 'todos';

  @override
  Future<List<TodoModel>> getTodos() async {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];

    final List decoded = json.decode(jsonString);
    return decoded.map((e) => TodoModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    final jsonString = json.encode(todos.map((e) => e.toJson()).toList());
    await prefs.setString(key, jsonString);
  }
}
