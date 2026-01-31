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
    try {
      loadingMessage.value = 'Loading....';
      tasks.value = await repo.getTasks();
    } catch (e) {
      StaticFunctions.toastMessage(msg: 'Something went wrong');
    }
    loadingMessage.value = '';
  }

  Future<void> addTask(String title, String description) async {
    try {
      loadingMessage.value = 'Saving task....';
      final task = Task(
        title: title,
        description: description,
        status: selectedTaskStatus.value,
        lastUpdatedAt: DateTime.now(),
        lastSyncedAt: null,
        isDirty: true,
      );

      final result = await repo.insertTask(task);
      if (result == 1) {
        await _loadTasks();
        StaticFunctions.toastMessage(
          msg: 'Task added successfully',
          isSuccessMsg: true,
        );
        Get.back();
      } else {
        StaticFunctions.toastMessage(
          msg: 'Task is not added. Something went wrong.',
        );
      }
    } catch (e) {
      StaticFunctions.toastMessage(msg: 'Something went wrong');
    }

    loadingMessage.value = '';
  }

  Future<void> updateTask(
    Task task, {
    required String title,
    required String description,
    required String status,
  }) async {
    try {
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

      final result = await repo.updateTask(updatedTask);

      if (result == 1) {
        await _loadTasks();
        StaticFunctions.toastMessage(
          msg: 'Task edited successfully',
          isSuccessMsg: true,
        );
        Get.back();
      } else {
        StaticFunctions.toastMessage(
          msg: 'Task is not edited. Something went wrong.',
        );
      }
    } catch (e) {
      StaticFunctions.toastMessage(msg: 'Something went wrong');
    }

    loadingMessage.value = '';
  }

  Future<void> syncTasks() async {
    try {
      loadingMessage.value = 'Syncing tasks....';

      bool isError = false;
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
        final result = await repo.updateTask(syncedTask);

        if (result != 1) {
          isError = true;
        }
      }
      if (!isError) {
        await _loadTasks();
        StaticFunctions.toastMessage(
          msg: 'Task sync successfully',
          isSuccessMsg: true,
        );
      } else {
        StaticFunctions.toastMessage(msg: 'Some Task are not sync');
      }
    } catch (e) {
      StaticFunctions.toastMessage(msg: 'Something went wrong');
    }

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
    Get.to(() => TaskAddEditScreen(isAddTask: isAddTask, task: task));
  }
}
