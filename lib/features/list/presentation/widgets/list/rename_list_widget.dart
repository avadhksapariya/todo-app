import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_strings.dart';
import '../../bloc/list_bloc.dart';

void showRenameDialog(BuildContext context, String listId, String current) {
  final ctrl = TextEditingController(text: current);
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(AppStrings.renameList),
      content: TextField(controller: ctrl, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            final t = ctrl.text.trim();
            if (t.isNotEmpty) {
              context.read<ListBloc>().add(ListRenamed(listId, t));
              Navigator.pop(context);
            }
          },
          child: const Text(AppStrings.save),
        ),
      ],
    ),
  );
}
