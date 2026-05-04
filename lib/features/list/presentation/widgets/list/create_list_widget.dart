import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_strings.dart';
import '../../bloc/list_bloc.dart';

void showCreateListDialog(BuildContext context, String userId) {
  final ctrl = TextEditingController();
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(AppStrings.newList),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: const InputDecoration(hintText: AppStrings.listName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            final t = ctrl.text.trim();
            if (t.isNotEmpty) {
              context.read<ListBloc>().add(ListCreated(userId, t));
              Navigator.pop(context);
            }
          },
          child: const Text(AppStrings.create),
        ),
      ],
    ),
  );
}
