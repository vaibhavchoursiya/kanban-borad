import 'package:kanban_board/models/task_model.dart';

class Collection {
  final String collectionName;
  final List<Task> pending;
  final List<Task> inProcess;
  final List<Task> completed;

  Collection(
      {required this.collectionName,
      required this.pending,
      required this.inProcess,
      required this.completed});
}
