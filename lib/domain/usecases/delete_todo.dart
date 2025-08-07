// delete_todo.dart
import '../repositories/todo_repository.dart';

class DeleteTodo {
  final TodoRepository repository;
  DeleteTodo(this.repository);

  Future<void> call(String id) => repository.deleteTodo(id);
}
