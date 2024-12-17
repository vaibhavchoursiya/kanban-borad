import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/providers/task_panel_provider.dart';
import 'package:kanban_board/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

class TaskPanel extends StatefulWidget {
  final String collectionName;
  const TaskPanel({super.key, required this.collectionName});

  @override
  State<TaskPanel> createState() => _TaskPanelState();
}

class _TaskPanelState extends State<TaskPanel> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initlizeFunc();
    });
  }

  Future<void> initlizeFunc() async {
    final taskPanelProvider = context.read<TaskPanelProvider>();
    await taskPanelProvider.getAllTasksFunc(widget.collectionName);
    taskPanelProvider.updateInitialLoader(false);
  }

  @override
  Widget build(BuildContext context) {
    final initlialLoader = context
        .select<TaskPanelProvider, bool>((provider) => provider.initialLoader);
    final pendingList = context.watch<TaskPanelProvider>().pending;
    final inProgress = context.watch<TaskPanelProvider>().inProcess;
    final completedList = context.watch<TaskPanelProvider>().completed;

    return Scaffold(
      backgroundColor: AppTheme.dark,
      appBar: AppBar(
        backgroundColor: AppTheme.dark,
        leading: IconButton(
            onPressed: () {
              final taskPanelProvider = context.read<TaskPanelProvider>();
              taskPanelProvider.resetProvider();
              context.go("/home");
            },
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: AppTheme.light,
            )),
        centerTitle: true,
        title: Text(
          "Task Panel For ${widget.collectionName}",
          style: GoogleFonts.comicNeue(color: AppTheme.light),
        ),
      ),
      body: (initlialLoader)
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.light,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 2 * 0.20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TaskColumn(
                        headColor: Colors.red,
                        headText: "pending",
                        length: pendingList.length,
                        taskList: context.read<TaskPanelProvider>().pending,
                        // cardColor: AppTheme.primary,
                        cardColor: Colors.black54,

                        collectionName: widget.collectionName,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      TaskColumn(
                        headColor: Colors.yellow.shade700.withOpacity(0.9),
                        headText: "in progress",
                        length: inProgress.length,
                        taskList: context.read<TaskPanelProvider>().inProcess,
                        cardColor: Colors.black54,
                        collectionName: widget.collectionName,
                      ),
                      const SizedBox(
                        width: 16.0,
                      ),
                      TaskColumn(
                        headColor: Colors.green,

                        headText: "completed",
                        length: completedList.length,
                        taskList: context.read<TaskPanelProvider>().completed,
                        // cardColor: Colors.greenAccent,
                        cardColor: Colors.black54,

                        collectionName: widget.collectionName,
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}

class TaskColumn extends StatelessWidget {
  final String headText;
  final int length;
  final List taskList;
  final Color cardColor;
  final String collectionName;
  final Color headColor;
  const TaskColumn({
    super.key,
    required this.headText,
    required this.length,
    required this.taskList,
    required this.cardColor,
    required this.collectionName,
    required this.headColor,
  });

  Future taskDialogBox(context) async {
    // show dialog
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppTheme.dark,
            title: Text(
              "Add Task",
              style: GoogleFonts.comicNeue(
                color: AppTheme.light,
              ),
            ),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: AppTheme.light,
                ),
                onPressed: () {
                  context.read<TaskPanelProvider>().resetAddTaskScreen();
                  context.pop();
                },
                icon: Icon(
                  Icons.cancel,
                  color: AppTheme.light,
                ),
                label: const Text("cancel"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade400,
                  foregroundColor: AppTheme.light,
                ),
                onPressed: () async {
                  final taskPanelProvider = context.read<TaskPanelProvider>();
                  await taskPanelProvider.addTaskFunc(collectionName);
                  taskPanelProvider.resetAddTaskScreen();

                  if (context.mounted) {
                    context.pop();
                  }
                },
                icon: Icon(
                  Icons.save,
                  color: AppTheme.light,
                ),
                label: const Text("save"),
              )
            ],
            content: const AddTaskScreen(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 10.0,
          color: cardColor,
          child: Container(
            width: 300.0,
            height: 500.0,
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: headColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          headText,
                          style: GoogleFonts.comicNeue(
                            color: AppTheme.light,
                            fontWeight: FontWeight.bold,
                            fontSize: 15.0,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await taskDialogBox(context);
                          },
                          icon: Icon(
                            Icons.add,
                            color: AppTheme.light,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                TaskListWidget(
                  length: length,
                  taskList: taskList,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TaskListWidget extends StatelessWidget {
  final int length;
  final List taskList;
  const TaskListWidget({
    super.key,
    required this.length,
    required this.taskList,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          context
              .read<TaskPanelProvider>()
              .reorderListFunc(oldIndex, newIndex, taskList[0].status);
        },
        itemCount: length,
        itemBuilder: (context, index) {
          final task = taskList[index];
          Color intColor = Colors.greenAccent;
          switch (task.prority) {
            case "high":
              intColor = Colors.redAccent;
              break;

            case "low":
              intColor = Colors.blueAccent.withOpacity(0.5);

              break;
          }
          return ReorderableDragStartListener(
            key: ValueKey(task.taskId),
            index: index,
            child: Card(
              color: AppTheme.dark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 60.0,
                child: Row(
                  children: [
                    Container(
                      width: 20.0,
                      decoration: BoxDecoration(
                          color: intColor,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          )),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          task.taskTitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.comicNeue(
                            color: AppTheme.light.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final taskPanelProvider =
                            context.read<TaskPanelProvider>();
                        await taskPanelProvider.deleteTaskFunc(
                            task.taskId, task.collectionName);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: AppTheme.light,
                        size: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
