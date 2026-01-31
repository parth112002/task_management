import 'package:sqflite/sqflite.dart';

import '../const/static_functions.dart';
import '../service/task_service.dart';
import '../model/task.dart';

class TaskRepository {
  Future<List<Task>> getTasks() async {
    try {
      final db = await TaskService.instance.database;
      final result = await db.query('tasks', orderBy: 'id DESC');
      return result.map((e) => Task.fromJson(e)).toList();
    } on DatabaseException catch (e) {
      _dbCatch(e);
    }
    return [];
  }

  Future<int> insertTask(Task task) async {
    try {
      final db = await TaskService.instance.database;
      return await db.insert(
        'tasks',
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException catch (e) {
      _dbCatch(e);
    }
    return 0;
  }

  Future<int> updateTask(Task task) async {
    try {
      final db = await TaskService.instance.database;
      return await db.update(
        'tasks',
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    } on DatabaseException catch (e) {
      _dbCatch(e);
    }
    return 0;
  }

  void _dbCatch(DatabaseException e) {
    final code = e.getResultCode();

    if (code == 13) {
      // storage full
      StaticFunctions.toastMessage(msg: 'Storage is Full');
    } else if (code == 8) {
      // read only
      StaticFunctions.toastMessage(msg: 'DB is read only');
    } else if (code == 14) {
      // can't open DB
      StaticFunctions.toastMessage(msg: 'Something went wrong');
    }
  }
}
