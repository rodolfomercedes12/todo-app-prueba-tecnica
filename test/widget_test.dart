import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app_prueba_tecnica/data/datasources/todo_local_datasource.dart';
import 'package:todo_app_prueba_tecnica/data/repositories/todo_repository_impl.dart';
import 'package:todo_app_prueba_tecnica/domain/usecases/add_todo.dart';
import 'package:todo_app_prueba_tecnica/domain/usecases/delete_todo.dart';
import 'package:todo_app_prueba_tecnica/domain/usecases/get_todos.dart';
import 'package:todo_app_prueba_tecnica/domain/usecases/toggle_todo.dart';
import 'package:todo_app_prueba_tecnica/presentation/bloc/todo_bloc.dart';
import 'package:todo_app_prueba_tecnica/presentation/pages/todo_page.dart';

void main() {
  testWidgets('Agregar tarea y mostrar en la lista',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({}); // Inicializa prefs vacías
    final prefs = await SharedPreferences.getInstance();
    final datasource = TodoLocalDatasourceImpl(prefs);
    final repository = TodoRepositoryImpl(datasource);

    final testApp = MaterialApp(
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

    await tester.pumpWidget(testApp);

    // Escribe una tarea
    await tester.enterText(find.byType(TextField), 'Hacer ejercicio');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifica que la tarea fue agregada
    expect(find.text('Hacer ejercicio'), findsOneWidget);
  });
}
