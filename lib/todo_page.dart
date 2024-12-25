import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:riverpod_speech_appoach/todo/todo.dart';

import 'notifier/todo_filter_notifier.dart';
import 'notifier/todos_notifier.dart';
import 'providers/provider.dart';
import 'todo/todo_filter.dart';

// 9. Todo List Page
class TodoListPage extends ConsumerWidget {
  final TextEditingController _textController = TextEditingController();

  TodoListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the filtered todos provider
    final filteredTodos = ref.watch(filteredTodosProvider);
    final todosAsync = ref.watch(todosNotifierProvider);
    ref.listen(todosNotifierProvider, (prev, current) {
      if (current.isLoading) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildList(context, todosAsync, ref, filteredTodos),
            _buildAddWidget(ref),
          ],
        ),
      ),
    );
  }

  Expanded _buildList(BuildContext context, AsyncValue<List<Todo>> todosAsync, WidgetRef ref, List<Todo> filteredTodos) {
    return Expanded(
      child: Column(
        children: [
          if (todosAsync.hasError)
            Text(
              'Error: ${todosAsync.error}',
              style: const TextStyle(color: Colors.red),
            ),
          if (todosAsync.hasValue)
            Expanded(
              child: Column(
                children: [
                  const StatusBarWidget(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => ref.refresh(todosNotifierProvider.future),
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: filteredTodos
                              .map((todo) => ListTile(
                                    title: Text(todo.title),
                                    leading: Checkbox(
                                      value: todo.isCompleted,
                                      onChanged: (value) {
                                        ref.read(todosNotifierProvider.notifier).toggleTodo(todo);
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAddWidget(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter a todo item',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(todosNotifierProvider.notifier).addTodo(_textController.text);
              _textController.clear();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class StatusBarWidget extends ConsumerWidget {
  const StatusBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: TodoFilter.values
          .map((filter) => ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith((states) {
                    return ref.watch(todoFilterNotifierProvider) == filter ? Theme.of(context).primaryColor : null;
                  }),
                  foregroundColor: WidgetStateProperty.resolveWith((states) {
                    return ref.watch(todoFilterNotifierProvider) == filter ? Colors.white : null;
                  }),
                ),
                onPressed: () {
                  ref.read(todoFilterNotifierProvider.notifier).setFilter(filter);
                },
                child: Text(filter.name),
              ))
          .toList(),
    );
  }
}