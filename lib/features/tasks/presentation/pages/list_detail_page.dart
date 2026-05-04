import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/app_colors.dart';

import '../../../../core/app_strings.dart';
import '../../../../core/app_utils.dart';
import '../../../list/domain/entities/todo_list_entity.dart';
import '../bloc/task_bloc.dart';
import '../widgets/add_task_widget.dart';
import '../widgets/delete_task_dialog.dart';
import '../widgets/edit_task_widget.dart';
import '../widgets/task_card_widget.dart';

class ListDetailPage extends StatelessWidget {
  final TodoListEntity listEntity;

  const ListDetailPage({super.key, required this.listEntity});

  @override
  Widget build(BuildContext context) {
    context.read<TaskBloc>().add(TasksSubscribed(listEntity.id));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          listEntity.title,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
        actions: [
          BlocBuilder<TaskBloc, TasksState>(
            builder: (context, state) {
              return PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'all') {
                    context.read<TaskBloc>().add(
                      const TaskFilterChanged(TaskFilter.all),
                    );
                  } else if (v == 'pending') {
                    context.read<TaskBloc>().add(
                      const TaskFilterChanged(TaskFilter.pending),
                    );
                  } else if (v == 'completed') {
                    context.read<TaskBloc>().add(
                      const TaskFilterChanged(TaskFilter.completed),
                    );
                  } else if (v == 'byDate') {
                    context.read<TaskBloc>().add(
                      const TaskSortChanged(TaskSort.byDate),
                    );
                  } else if (v == 'byStatus') {
                    context.read<TaskBloc>().add(
                      const TaskSortChanged(TaskSort.byStatus),
                    );
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    enabled: false,
                    child: Text(
                      AppStrings.filter,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'all',
                    child: Row(
                      children: [
                        if (state.filter == TaskFilter.all)
                          const Icon(Icons.check, size: 16),
                        const SizedBox(width: 8),
                        const Text(AppStrings.showAll),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'pending',
                    child: Row(
                      children: [
                        if (state.filter == TaskFilter.pending)
                          const Icon(Icons.check, size: 16),
                        const SizedBox(width: 8),
                        const Text(AppStrings.pendingOnly),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'completed',
                    child: Row(
                      children: [
                        if (state.filter == TaskFilter.completed)
                          const Icon(Icons.check, size: 16),
                        const SizedBox(width: 8),
                        const Text(AppStrings.completedOnly),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    enabled: false,
                    child: Text(
                      AppStrings.sort,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'byDate',
                    child: Row(
                      children: [
                        if (state.sort == TaskSort.byDate)
                          const Icon(Icons.check, size: 16),
                        const SizedBox(width: 8),
                        const Text(AppStrings.byDate),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'byStatus',
                    child: Row(
                      children: [
                        if (state.sort == TaskSort.byStatus)
                          const Icon(Icons.check, size: 16),
                        const SizedBox(width: 8),
                        const Text(AppStrings.byStatus),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TasksState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = state.filteredTasks;

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: AppColors.greyLight),
                  const SizedBox(height: 16),
                  const Text(
                    AppStrings.noTasks,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.noTasksInfo,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return AnimatedList(
            key: ValueKey(tasks.length),
            padding: const EdgeInsets.all(16),
            initialItemCount: tasks.length,
            itemBuilder: (context, index, animation) {
              final task = tasks[index];
              return SizeTransition(
                sizeFactor: animation,
                child: TaskCard(
                  task: task,
                  listId: listEntity.id,
                  onEdit: () => showEditTaskDialog(context, task),
                  onDelete: () => confirmDeleteTask(context, task.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => showAddTaskDialog(context, listEntity),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
