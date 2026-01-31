import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/task.dart';
import '../../../state/task_controller.dart';

class TaskAddEditScreen extends StatefulWidget {
  final bool isAddTask;
  final Task? task;

  const TaskAddEditScreen({
    super.key,
    required this.isAddTask,
    this.task,
  });

  @override
  State<TaskAddEditScreen> createState() => _TaskAddEditScreenState();
}

class _TaskAddEditScreenState extends State<TaskAddEditScreen> {
  late final TaskController _controller;
  late final TextEditingController _titleTextController;
  late final TextEditingController _descriptionTextController;
  late final GlobalKey<FormState> _formKey;

  @override
  void initState() {
    _controller = Get.find<TaskController>();

    _titleTextController = TextEditingController();
    _descriptionTextController = TextEditingController();
    _formKey = GlobalKey<FormState>();

    if (!widget.isAddTask && widget.task != null) {
      _titleTextController.text = widget.task!.title;
      _descriptionTextController.text = widget.task!.description;
      _controller.selectedTaskStatus.value = widget.task!.status;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isAddTask ? 'Add Task' : 'Edit Task'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                _verticalSpaceBetweenWidgets(),
                _titleField(),
                _verticalSpaceBetweenWidgets(),
                _descriptionField(),
                _verticalSpaceBetweenWidgets(),
                _taskStatusDropDown(),
                _verticalSpaceBetweenWidgets(),
                _saveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _titleField() {
    return TextFormField(
      controller: _titleTextController,
      decoration: InputDecoration(hint: Text('Title')),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Title is required';
        }
        return null;
      },
    );
  }

  Widget _descriptionField() {
    return TextFormField(
      controller: _descriptionTextController,
      decoration: InputDecoration(hint: Text('Description')),
    );
  }

  Widget _taskStatusDropDown() {
    return Obx(
      () => DropdownButton<String>(
        value: _controller.selectedTaskStatus.value,
        onChanged: (value) => _controller.onTaskStatusDropDownChange(value),
        items: _controller.taskStatus.map(
              (status) => DropdownMenuItem(
            value: status,
            child: Text(status),
          ),
        ).toList(),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (widget.isAddTask) {
              await _controller.addTask(
                _titleTextController.text.trim(),
                _descriptionTextController.text.trim(),
              );
            } else {
              await _controller.updateTask(
                widget.task!,
                title: _titleTextController.text.trim(),
                description: _descriptionTextController.text.trim(),
                status: _controller.selectedTaskStatus.value,
              );
            }
          }
        },
        child: const Text('Save'),
      ),
    );
  }

  Widget _verticalSpaceBetweenWidgets() {
    return SizedBox(height: 15);
  }
}