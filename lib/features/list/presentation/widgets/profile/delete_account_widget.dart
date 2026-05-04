import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_colors.dart';
import '../../../../../core/app_strings.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

void confirmDeleteAccount(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(AppStrings.deleteAccount),
      content: const Text(AppStrings.deleteAccountInfo),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthDeleteAccountRequested());
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          child: const Text(AppStrings.deleteAccount),
        ),
      ],
    ),
  );
}
