import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/static_functions.dart';
import '../model/task.dart';
import '../repository/task_repository.dart';
import '../ui/task/add_edit/task_add_edit_screen.dart';

class TaskController extends GetxController {
  final RxList<Task> tasks = <Task>[].obs;
  final TaskRepository repo = TaskRepository();
  final List<String> taskStatus = ['Pending', 'Completed'];
  final RxString selectedTaskStatus = 'Pending'.obs;
  final RxString loadingMessage = ''.obs;

  @override
  void onInit() {
    _loadingDialogEver();
    _loadTasks();
    super.onInit();
  }

  void _loadingDialogEver() {
    ever(loadingMessage, (message) {
      if (message.isNotEmpty) {
        StaticFunctions.showLoading(message);
      } else {
        Get.back();
      }
    });
  }

  Future<void> _loadTasks() async {
    loadingMessage.value = 'Loading....';
    tasks.value = await repo.getTasks();
    loadingMessage.value = '';
  }

  Future<void> addTask(String title, String description) async {
    loadingMessage.value = 'Saving task....';
    final task = Task(
      title: title,
      description: description,
      status: selectedTaskStatus.value,
      lastUpdatedAt: DateTime.now(),
      lastSyncedAt: null,
      isDirty: true,
    );

    await repo.insertTask(task);
    await _loadTasks();

    loadingMessage.value = '';
  }

  Future<void> updateTask(
      Task task, {
        required String title,
        required String description,
        required String status,
      }) async {
    loadingMessage.value = 'Editing task....';

    final updatedTask = Task(
      id: task.id,
      title: title,
      description: description,
      status: status,
      lastUpdatedAt: DateTime.now(),
      lastSyncedAt: task.lastSyncedAt,
      isDirty: true,
    );

    await repo.updateTask(updatedTask);
    await _loadTasks();

    loadingMessage.value = '';
  }

  Future<void> syncTasks() async {
    loadingMessage.value = 'Syncing tasks....';

    for (final task in tasks.where((t) => t.isDirty)) {
      final syncedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        status: task.status,
        lastUpdatedAt: task.lastUpdatedAt,
        lastSyncedAt: DateTime.now(),
        isDirty: false,
      );
      await repo.updateTask(syncedTask);
    }
    await _loadTasks();

    loadingMessage.value = '';
  }

  void onTaskStatusDropDownChange(String? value) {
    selectedTaskStatus.value = value ?? '';
  }

  void navigateToAddEditScreen({
    required BuildContext context,
    required bool isAddTask,
    Task? task,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskAddEditScreen(
          isAddTask: isAddTask,
          task: task,
        ),
      ),
    );
  }
}
