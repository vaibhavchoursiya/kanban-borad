import 'package:kanban_board/models/task_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class DbService {
  static late Database db;

  static Future<void> setupDB() async {
    var databaseFactory = databaseFactoryFfi;

    final io.Directory appDocumentDir =
        await getApplicationDocumentsDirectory();

    String dbPath = p.join(appDocumentDir.path, "kandam_db", "appdb.db");
    db = await databaseFactory.openDatabase(dbPath);
    // print(db);
  }

  static Future<void> createCollection(String tableName) async {
    await db.execute('''
      CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY,
      taskTitle TEXT,
      description TEXT,
      prority TEXT,
      status TEXT,
      deadline TEXT
      )
      ''');
  }

  static Future<void> deleteCollection(String tableName) async {
    await db.execute('''
      DROP TABLE $tableName
    ''');
  }

  static Future<void> addItem(Task task, String tableName) async {
    await db.execute('''
      INSERT INTO $tableName(taskTitle, description, prority, status, deadline)
      VALUES(${task.taskTitle}, ${task.description}, ${task.prority}, ${task.status}, ${task.deadline})
    ''');
  }
}
