import 'package:flutter/material.dart';
import 'package:kanban_board/models/task_model.dart';
import 'package:kanban_board/services/db_service.dart';

class TaskPanelProvider extends ChangeNotifier {
  bool initialLoader = true;

  TextEditingController taskTitleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List statusList = ["pending", "in progress", "completed"];
  List priorityList = ["high", "low", "medium"];
  String priorityValue = "low";
  String statusValue = "pending";

  List pending = <Task>[];
  List inProcess = <Task>[];
  List completed = <Task>[];

  updateInitialLoader(bool value) {
    initialLoader = value;
    notifyListeners();
  }

  resetStatusList() {
    pending.clear();
    inProcess.clear();
    completed.clear();
  }

  resetAddTaskScreen() {
    taskTitleController.clear();
    descriptionController.clear();
    priorityValue = "low";
    statusValue = "pending";
  }

  Future getAllTasksFunc(String collectionName) async {
    resetStatusList();

    final List tasksList = await DbService.getAllTasks(collectionName);
    print(tasksList);
    print(collectionName);
    if (tasksList.isNotEmpty) {
      for (var i = 0; i < tasksList.length; i++) {
        switch (tasksList[i]["status"]) {
          case "pending":
            pending.add(Task.fromMap(tasksList[i]));
            break;
          case "in progress":
            inProcess.add(Task.fromMap(tasksList[i]));
            break;
          case "completed":
            completed.add(Task.fromMap(tasksList[i]));
            break;
        }
      }
    }
  }

  Future addTaskFunc(colletionName) async {
    Task task = Task(
        taskTitle: taskTitleController.text.trim(),
        description: descriptionController.text.trim(),
        prority: priorityValue,
        status: statusValue,
        collectionName: colletionName);

    await DbService.addTask(task);
    await getAllTasksFunc(colletionName);
    notifyListeners();
  }

  Future deleteTaskFunc(int id, String collectionName) async {
    await DbService.deleteTask(id);
    await getAllTasksFunc(collectionName);
    notifyListeners();
  }

  Future updateTaskFunc() async {}

  resetProvider() {
    initialLoader = true;
    resetStatusList();
  }
}
