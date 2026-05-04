import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/app_colors.dart';
import 'package:todo_app/core/app_strings.dart';

import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../tasks/presentation/pages/list_detail_page.dart';
import '../bloc/list_bloc.dart';
import '../widgets/list/create_list_widget.dart';
import '../widgets/list/delete_list_widget.dart';
import '../widgets/list/rename_list_widget.dart';
import 'profile_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userId = authState is AuthAuthenticated ? authState.user.id : '';
    final userEmail = authState is AuthAuthenticated
        ? authState.user.email
        : '';

    // Subscribe to lists when userId is available
    if (userId.isNotEmpty) {
      context.read<ListBloc>().add(ListsSubscribed(userId));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          AppStrings.myLists,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
              color: AppColors.primary,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProfilePage(email: userEmail)),
            ),
          ),
        ],
      ),
      body: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is ListsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ListsLoaded) {
            if (state.lists.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.list_alt, size: 80, color: AppColors.greyLight),
                    const SizedBox(height: 16),
                    const Text(
                      AppStrings.noLists,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      AppStrings.noListsInfo,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ListBloc>().add(ListsSubscribed(userId));
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.lists.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final list = state.lists[index];
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.list_alt,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        list.title,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'rename') {
                            showRenameDialog(context, list.id, list.title);
                          }
                          if (v == 'delete') {
                            confirmDelete(context, list.id, list.title);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'rename',
                            child: Text(AppStrings.rename),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              AppStrings.delete,
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ListDetailPage(listEntity: list),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          if (state is ListsFailure) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => showCreateListDialog(context, userId),
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
