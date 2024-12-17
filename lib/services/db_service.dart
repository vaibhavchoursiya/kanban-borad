import 'package:flutter/foundation.dart';
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

    await createCollectionNameTable();
    await createKanbanTable();
  }

  static Future<void> createCollectionNameTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS collectionNames(
      id INTEGER PRIMARY KEY,
      cn TEXT
      );
''');
  }

  static Future<void> createKanbanTable() async {
    /* How to handle tableName and anything if user enter*/

    await db.execute('''
      CREATE TABLE IF NOT EXISTS kanban(
      id INTEGER PRIMARY KEY,
      taskTitle TEXT,
      description TEXT,
      prority TEXT,
      status TEXT,
      collectionName TEXT
);
''');
  }

  static Future<void> addTask(Task task) async {
    await db.rawInsert('''
      INSERT INTO kanban(taskTitle, description, prority, status, collectionName)
      VALUES("${task.taskTitle}", "${task.description}", "${task.prority}", "${task.status}", "${task.collectionName}");
''');
  }

  static Future getAllTasks(String collectionName) async {
    final List query = await db.rawQuery(
        '''SELECT * FROM kanban WHERE collectionName = "$collectionName"''');

    return query;
  }

  static Future deleteTask(int id) async {
    await db.rawDelete('''DELETE FROM kanban WHERE id = ?''', [id]);
  }

  static Future updateTask(Task task) async {
    print(task.taskId);
    await db.rawUpdate(
        'UPDATE kanban SET taskTitle = ?, description = ?, prority = ?, status = ? WHERE id = ?',
        [
          task.taskTitle,
          task.description,
          task.prority,
          task.status,
          task.taskId
        ]);
  }

  // add, delete, update, get all

  static Future<void> addCollectionName(String collectionName) async {
    try {
      await db.execute('''
      INSERT INTO collectionNames(cn) VALUES("$collectionName");
      ''');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future getAllCollectionNames() async {
    final cns = await db.query("collectionNames");
    return cns;
  }

  static Future<void> deleteCollection(String collectionName) async {
    try {
      await db.execute(
          '''DELETE FROM collectionNames WHERE cn = "$collectionName"''');
      await db.execute('''
      DELETE FROM kanban WHERE collectionName = "$collectionName"
    ''');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
