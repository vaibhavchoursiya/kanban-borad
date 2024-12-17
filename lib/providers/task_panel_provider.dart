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

  resetController() {
    taskTitleController.clear();
    descriptionController.clear();
  }

  resetValues() {
    priorityValue = "low";
    statusValue = "pending";
  }

  resetAddTaskScreen() {
    resetStatusList();
    resetController();
    resetValues();
  }

  /// Get all the tasks based on collectionName.
  /// And put then in different List based on task.status.
  Future getAllTasksFunc(String collectionName) async {
    resetStatusList();

    final List tasksList = await DbService.getAllTasks(collectionName);

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
    notifyListeners();
  }

  Future addTaskFunc(colletionName) async {
    Task task = Task(
        taskTitle: taskTitleController.text.trim(),
        description: descriptionController.text.trim(),
        prority: priorityValue,
        status: statusValue,
        collectionName: colletionName);

    await DbService.addTask(task);

    // Clean = >  statusLists, controller, values
    resetController();
    resetValues();
    await getAllTasksFunc(colletionName);
  }

  Future deleteTaskFunc(int id, String collectionName) async {
    await DbService.deleteTask(id);
    await getAllTasksFunc(collectionName);
    notifyListeners();
  }

  /// Set all controllers and value.
  setDataInControllers(Task task) {
    taskTitleController.text = task.taskTitle;
    descriptionController.text = task.description;
    priorityValue = task.prority;
    statusValue = task.status;
    // notifyListeners();
  }

  Future updateTaskFunc(collectionName, int id) async {
    Task task = Task(
        taskId: id,
        taskTitle: taskTitleController.text.trim(),
        description: descriptionController.text.trim(),
        prority: priorityValue,
        status: statusValue,
        collectionName: collectionName);

    await DbService.updateTask(task);

    // Clean = >  statusLists, controller, values
    resetController();
    resetValues();
    await getAllTasksFunc(collectionName);
  }

  reorderListFunc(int oldIndex, int newIndex, String taskStatus) {
    if (oldIndex < newIndex) {
      newIndex--;
    }

    switch (taskStatus) {
      case "pending":
        final item = pending.removeAt(oldIndex);
        pending.insert(newIndex, item);

        break;

      case "in progress":
        final item = inProcess.removeAt(oldIndex);
        inProcess.insert(newIndex, item);
        break;

      case "completed":
        final item = completed.removeAt(oldIndex);
        completed.insert(newIndex, item);
        break;
    }

    notifyListeners();
  }

  resetProvider() {
    initialLoader = true;
    resetAddTaskScreen();
  }
}
