import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../todo/todo_filter.dart';

part 'todo_filter_notifier.g.dart';

// 5. Filter Notifier
@riverpod
class TodoFilterNotifier extends _$TodoFilterNotifier {
  @override
  TodoFilter build() {
    return TodoFilter.all;
  }

  void setFilter(TodoFilter filter) {
    state = filter;
  }
}
