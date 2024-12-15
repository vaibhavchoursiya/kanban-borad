class Task {
  final String taskTitle;
  final String description;
  final String prority; // high, low and medium.
  final String status; // pending, in progress, and completed.
  final DateTime deadline; // in unix or String format

  Task(
      {required this.taskTitle,
      required this.description,
      required this.prority,
      required this.status,
      required this.deadline});
}
