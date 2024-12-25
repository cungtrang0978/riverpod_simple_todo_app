import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo/todo.dart';

part 'todo_service.g.dart';

@Riverpod(keepAlive: true)
TodoService todoService(Ref ref) {
  return TodoService();
}

class TodoService {
  // Simulate network delay
  Future<List<Todo>> fetchTodos() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
        5, (index) => Todo(id: '${DateTime.now().millisecondsSinceEpoch}_$index', title: 'Todo Item ${index + 1}', isCompleted: Random().nextBool()));
  }

  Future<Todo> addTodo(String title) async {
    await Future.delayed(const Duration(seconds: 1));
    return Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
  }

  Future<Todo> toggleTodo(Todo todo) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return todo.copyWith(isCompleted: !todo.isCompleted);
  }
}
