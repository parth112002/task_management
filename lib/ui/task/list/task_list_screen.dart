import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../state/task_controller.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final TaskController _controller;

  @override
  void initState() {
    _controller = Get.put(TaskController());
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      floatingActionButton: _addTaskButton(),
      body: SafeArea(
        child: _taskList(),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text('Task Management System'),
      actions: [
        IconButton(
          icon: Icon(Icons.sync),
          onPressed: _controller.syncTasks,
        ),
      ],
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _controller.navigateToAddEditScreen(
        context: context,
        isAddTask: true,
      ),
    );
  }

  Widget _taskList() {
    return Obx(
      () => _controller.tasks.isNotEmpty ? ListView.builder(
        itemCount: _controller.tasks.length,
        itemBuilder: (context, index) {
          final task = _controller.tasks[index];
          return GestureDetector(
            onTap: () => _controller.navigateToAddEditScreen(
              context: context,
              isAddTask: false,
              task: task,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: task.status == _controller.taskStatus[0] ? Colors.green : Colors.grey,
                child: Text(task.status == _controller.taskStatus[0] ? 'P' : 'C'),
              ),
              title: Text(task.title),
              subtitle: Text(task.description),
              trailing: Text(task.isDirty ? 'Not sync' : 'synced'),
            ),
          );
        },
      ) : Center(child: Text('No Task found')),
    );
  }
}
