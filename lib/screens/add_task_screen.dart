import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/providers/task_panel_provider.dart';
import 'package:kanban_board/utility/validator_model.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({
    super.key,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final priorityValue = context.select<TaskPanelProvider, String>(
        (provider) => provider.priorityValue);

    final statusValue = context
        .select<TaskPanelProvider, String>((provider) => provider.statusValue);

    return SizedBox(
      width: 400.0,
      child: Column(
        children: [
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MTextFormField(
                  controller:
                      context.read<TaskPanelProvider>().taskTitleController,
                  label: "Task title",
                  validator: ValidatorModel.notEmptyValidator,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MTextFormField(
                  controller:
                      context.read<TaskPanelProvider>().descriptionController,
                  label: "Task description",
                  validator: ValidatorModel.notEmptyValidator,
                  maxLine: 8,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    "Priority",
                    style: GoogleFonts.comicNeue(
                      color: AppTheme.light,
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  value: priorityValue,
                  onChanged: (value) {
                    context.read<TaskPanelProvider>().priorityValue =
                        value.toString();
                  },
                  style: GoogleFonts.comicNeue(color: AppTheme.light),
                  dropdownColor: AppTheme.dark,
                  decoration:
                      InputDecoration(filled: true, fillColor: AppTheme.dark),
                  items:
                      context.read<TaskPanelProvider>().priorityList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.comicNeue(),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    "Status",
                    style: GoogleFonts.comicNeue(
                      color: AppTheme.light,
                    ),
                  ),
                ),
                DropdownButtonFormField(
                  value: statusValue,
                  onChanged: (value) {
                    context.read<TaskPanelProvider>().statusValue =
                        value.toString();
                  },
                  style: GoogleFonts.comicNeue(color: AppTheme.light),
                  dropdownColor: AppTheme.dark,
                  decoration:
                      InputDecoration(filled: true, fillColor: AppTheme.dark),
                  items: context.read<TaskPanelProvider>().statusList.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.comicNeue(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function validator;
  final int maxLine;
  const MTextFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.maxLine = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) {
        return validator(value);
      },
      style: GoogleFonts.comicNeue(
        color: AppTheme.light,
      ),
      maxLines: maxLine,
      decoration: InputDecoration(
        label: Text(
          label,
          style: GoogleFonts.aDLaMDisplay(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
