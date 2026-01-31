import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskService {
  static final TaskService instance = TaskService._();
  static Database? _db;

  TaskService._();

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          status TEXT,
          lastUpdatedAt TEXT,
          lastSyncedAt TEXT,
          isDirty INTEGER
        )
        ''');
      },
    );
  }

  Future<void> close() async {
    if (_db != null) {
      await _db!.close();
      _db = null;
    }
  }
}
