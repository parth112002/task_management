import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './ui/task/list/task_list_screen.dart';
import './service/task_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // to close db when app is close
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management System',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TaskListScreen(),
    );
  }
}

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      TaskService.instance.close();
    }
  }
}
