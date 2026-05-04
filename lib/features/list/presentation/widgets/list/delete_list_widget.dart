import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_colors.dart';
import '../../../../../core/app_strings.dart';
import '../../bloc/list_bloc.dart';

void confirmDelete(BuildContext context, String listId, String title) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(AppStrings.deleteList),
      content: Text('Delete "$title" and all its tasks?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<ListBloc>().add(ListDeleted(listId));
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text(AppStrings.delete),
        ),
      ],
    ),
  );
}
