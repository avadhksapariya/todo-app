import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_strings.dart';
import '../../domain/entities/task_entity.dart';
import '../bloc/task_bloc.dart';

void showEditTaskDialog(BuildContext context, TaskEntity task) {
  final titleCtrl = TextEditingController(text: task.title);
  final descCtrl = TextEditingController(text: task.description ?? '');
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            AppStrings.editTask,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleCtrl,
            autofocus: true,
            decoration: const InputDecoration(labelText: AppStrings.taskTitle),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: descCtrl,
            decoration: const InputDecoration(
              labelText: AppStrings.description,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                final t = titleCtrl.text.trim();
                if (t.isNotEmpty) {
                  context.read<TaskBloc>().add(
                    TaskUpdated(
                      task.copyWith(
                        title: t,
                        description: descCtrl.text.trim().isEmpty
                            ? null
                            : descCtrl.text.trim(),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(AppStrings.save),
            ),
          ),
        ],
      ),
    ),
  );
}
