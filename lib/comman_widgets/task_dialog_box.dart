import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/providers/task_panel_provider.dart';
import 'package:kanban_board/screens/add_task_screen.dart';
import 'package:provider/provider.dart';

Future taskDialogBox(context, String collectionName) async {
  // show dialog
  await showDialog(
      barrierDismissible: false,
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
                context.read<TaskPanelProvider>().resetController();
                context.read<TaskPanelProvider>().resetValues();
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

Future updateDialogBox(
    context, Function taskFunc, String collectionName, int taskId) async {
  // show dialog
  await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.dark,
          title: Text(
            "Update Task",
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
                context.read<TaskPanelProvider>().resetController();
                context.read<TaskPanelProvider>().resetValues();
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
                await taskFunc(collectionName, taskId);

                if (context.mounted) {
                  context.pop();
                }
              },
              icon: Icon(
                Icons.save,
                color: AppTheme.light,
              ),
              label: const Text("update"),
            )
          ],
          content: const AddTaskScreen(),
        );
      });
}
