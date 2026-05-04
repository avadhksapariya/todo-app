import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/app_colors.dart';
import 'package:todo_app/features/list/data/datasources/firebase_list_data_source.dart';

import 'core/app_router.dart';
import 'core/app_strings.dart';
import 'core/app_styles.dart';
import 'features/auth/data/datasources/firebase_auth_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/list/data/repositories/list_repository_impl.dart';
import 'features/list/presentation/bloc/list_bloc.dart';
import 'features/tasks/data/datasources/firebase_task_data_source.dart';
import 'features/tasks/data/repositories/task_repository_impl.dart';
import 'features/tasks/presentation/bloc/task_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency injection via providers
    final authDS = FirebaseAuthDataSource(
      FirebaseAuth.instance,
      FirebaseFirestore.instance,
    );

    final firebaseListDS = FirebaseListDataSource(FirebaseFirestore.instance);
    final firebaseTaskDS = FirebaseTaskDataSource(FirebaseFirestore.instance);

    final authRepo = AuthRepositoryImpl(authDS);
    final listRepo = TodoListRepositoryImpl(firebaseListDS);
    final taskRepo = TaskRepositoryImpl(firebaseTaskDS);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepo)..add(AuthStarted())),
        BlocProvider(create: (_) => ListBloc(listRepo)),
        BlocProvider(create: (_) => TaskBloc(taskRepo)),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: AppColors.primary,
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.surface,
          inputDecorationTheme: AppStyles.inputDecorationTheme,
          filledButtonTheme: AppStyles.filledButtonTheme,
          cardTheme: AppStyles.cardTheme,
        ),
        home: const AppRouter(),
      ),
    );
  }
}
