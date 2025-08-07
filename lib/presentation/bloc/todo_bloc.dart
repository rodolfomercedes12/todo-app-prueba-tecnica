import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/todo.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/toggle_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final DeleteTodo deleteTodo;
  final ToggleTodo toggleTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.deleteTodo,
    required this.toggleTodo,
  }) : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    });

    on<AddTodoEvent>((event, emit) async {
      await addTodo(event.todo);
      add(LoadTodos());
    });

    on<DeleteTodoEvent>((event, emit) async {
      await deleteTodo(event.id);
      add(LoadTodos());
    });

    on<ToggleTodoEvent>((event, emit) async {
      await toggleTodo(event.id);
      add(LoadTodos());
    });
  }
}
