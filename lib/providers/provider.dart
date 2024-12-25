import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_simple_todo/todo/todo.dart';
import 'package:riverpod_simple_todo/todo/todo_filter.dart';

import '../notifier/todo_filter_notifier.dart';
import '../notifier/todos_notifier.dart';

part 'provider.g.dart';

@riverpod
List<Todo> filteredTodos(
  Ref ref,
) {
  final todos = ref.watch(todosNotifierProvider);
  final filter = ref.watch(todoFilterNotifierProvider);

  return todos.when(
    data: (todoList) {
      switch (filter) {
        case TodoFilter.active:
          return todoList.where((todo) => !todo.isCompleted).toList();
        case TodoFilter.completed:
          return todoList.where((todo) => todo.isCompleted).toList();
        case TodoFilter.all:
        default:
          return todoList;
      }
    },
    loading: () => [],
    error: (_, __) => [],
    skipLoadingOnReload: true,
  );
}
