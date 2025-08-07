import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasources/todo_local_datasource.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/usecases/add_todo.dart';
import 'domain/usecases/delete_todo.dart';
import 'domain/usecases/get_todos.dart';
import 'domain/usecases/toggle_todo.dart';
import 'presentation/bloc/todo_bloc.dart';
import 'presentation/pages/todo_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final datasource = TodoLocalDatasourceImpl(prefs);
  final repository = TodoRepositoryImpl(datasource);

  runApp(MyApp(repository));
}

class MyApp extends StatelessWidget {
  final TodoRepositoryImpl repository;

  const MyApp(this.repository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      home: BlocProvider(
        create: (_) => TodoBloc(
          getTodos: GetTodos(repository),
          addTodo: AddTodo(repository),
          deleteTodo: DeleteTodo(repository),
          toggleTodo: ToggleTodo(repository),
        )..add(LoadTodos()),
        child: TodoPage(),
      ),
    );
  }
}
