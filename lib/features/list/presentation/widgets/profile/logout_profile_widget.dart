import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_strings.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';

void confirmLogout(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text(AppStrings.signOut),
      content: const Text(AppStrings.signOutInfo),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        TextButton(
          onPressed: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
            Navigator.pop(context);
          },
          child: const Text(AppStrings.signOut),
        ),
      ],
    ),
  );
}
