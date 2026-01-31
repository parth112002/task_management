import 'package:sqflite/sqflite.dart';

import '../service/task_service.dart';
import '../model/task.dart';

class TaskRepository {
  Future<List<Task>> getTasks() async {
    final db = await TaskService.instance.database;
    final result = await db.query('tasks', orderBy: 'id DESC');
    return result.map((e) => Task.fromJson(e)).toList();
  }

  Future<int> insertTask(Task task) async {
    final db = await TaskService.instance.database;
    return await db.insert(
      'tasks',
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    final db = await TaskService.instance.database;
    await db.update(
      'tasks',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
}
