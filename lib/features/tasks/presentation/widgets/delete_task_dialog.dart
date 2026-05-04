import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_strings.dart';
import '../bloc/task_bloc.dart';

void confirmDeleteTask(BuildContext context, String taskId) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(AppStrings.deleteTask),
      content: const Text(AppStrings.deleteTaskInfo),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<TaskBloc>().add(TaskDeleted(taskId, taskId));
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text(AppStrings.delete),
        ),
      ],
    ),
  );
}
