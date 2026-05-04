import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_strings.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final String listId;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.listId,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          leading: Checkbox(
            value: task.isCompleted,
            activeColor: AppColors.primary,
            shape: const CircleBorder(),
            onChanged: (v) {
              context.read<TaskBloc>().add(
                TaskToggled(task.id, listId, v ?? false),
              );
            },
          ),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: task.isCompleted
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
            child: Text(task.title),
          ),
          subtitle: task.description != null
              ? Text(
                  task.description!,
                  style: TextStyle(
                    color: task.isCompleted
                        ? AppColors.greyLighter
                        : AppColors.textSecondary,
                    fontSize: 13,
                  ),
                )
              : null,
          trailing: PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'edit', child: Text(AppStrings.edit)),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  AppStrings.delete,
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
