import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../service/todo_service.dart';
import '../todo/todo.dart';

part 'todos_notifier.g.dart';

@riverpod
class TodosNotifier extends _$TodosNotifier {
  @override
  FutureOr<List<Todo>> build() {
    final todoService = ref.watch(todoServiceProvider);
    return todoService.fetchTodos();
  }

  Future<void> addTodo(String title) async {
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    try {
      final todoService = ref.read(todoServiceProvider);
      final newTodo = await todoService.addTodo(title);

      state = AsyncValue.data([
        newTodo,
        ...?state.value,
      ]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> toggleTodo(Todo todo) async {
    state = const AsyncValue.loading();

    try {
      final todoService = ref.read(todoServiceProvider);
      final updatedTodo = await todoService.toggleTodo(todo);

      state = AsyncValue.data([
        for (final t in state.value ?? [])
          t.id == updatedTodo.id ? updatedTodo : t
      ]);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}