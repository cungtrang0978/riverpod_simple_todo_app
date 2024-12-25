import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:riverpod_speech_appoach/riverpod_observer.dart';
import 'package:riverpod_speech_appoach/todo_page.dart';

// 8. Main App
void main() {
  runApp(
    ProviderScope(
      observers: [
        RiverpodObserver(),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp(
        title: 'Advanced Riverpod Todo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TodoListPage(),
      ),
    );
  }
}
