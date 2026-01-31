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
        GestureDetector(
          onTap: _controller.syncTasks,
          child: Icon(Icons.sync),
        )
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
      () => ListView.builder(
        itemCount: _controller.tasks.length,
        itemBuilder: (context, index) {
          final task = _controller.tasks[index];
          return ListTile(
            leading: task.isDirty ? CircleAvatar(
              backgroundColor: Colors.green,
              radius: 5,
            ) : SizedBox(),
            title: Text(task.title),
            subtitle: Text(task.description),
            trailing: GestureDetector(
              onTap: () => _controller.navigateToAddEditScreen(
                context: context,
                isAddTask: false,
                task: task,
              ),
              child: Icon(Icons.edit),
            ),
          );
        },
      ),
    );
  }
}
