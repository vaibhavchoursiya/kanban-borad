class Task {
  final int taskId;
  final String taskTitle;
  final String description;
  final String prority; // high, low and medium. // dropdown
  final String status; // pending, in progress, and completed. // radiobutton
  final String collectionName; // in unix or String format

  Task(
      {required this.taskTitle,
      required this.description,
      required this.prority,
      required this.status,
      required this.collectionName,
      this.taskId = -1});

  factory Task.fromMap(task) {
    return Task(
        taskId: task["id"],
        taskTitle: task["taskTitle"],
        description: task["description"],
        prority: task["prority"],
        status: task["status"],
        collectionName: task["collectionName"]);
  }
}
