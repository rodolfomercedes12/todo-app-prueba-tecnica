import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDatasource datasource;

  TodoRepositoryImpl(this.datasource);

  List<TodoModel> _todos = [];

  Future<void> _loadIfNeeded() async {
    if (_todos.isEmpty) {
      _todos = await datasource.getTodos();
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    await _loadIfNeeded();
    return _todos;
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await _loadIfNeeded();
    _todos.add(TodoModel(
      id: todo.id,
      title: todo.title,
      completed: todo.completed,
    ));
    await datasource.saveTodos(_todos);
  }

  @override
  Future<void> deleteTodo(String id) async {
    await _loadIfNeeded();
    _todos.removeWhere((t) => t.id == id);
    await datasource.saveTodos(_todos);
  }

  @override
  Future<void> toggleTodo(String id) async {
    await _loadIfNeeded();
    _todos = _todos.map((t) {
      if (t.id == id) {
        return TodoModel(
          id: t.id,
          title: t.title,
          completed: !t.completed,
        );
      }
      return t;
    }).toList();
    await datasource.saveTodos(_todos);
  }
}
