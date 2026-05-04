part of 'task_bloc.dart';

class TasksState extends Equatable {
  final List<TaskEntity> tasks;
  final bool isLoading;
  final String? error;
  final TaskFilter filter;
  final TaskSort sort;

  const TasksState({
    this.tasks = const [],
    this.isLoading = false,
    this.error,
    this.filter = TaskFilter.all,
    this.sort = TaskSort.byDate,
  });

  List<TaskEntity> get filteredTasks {
    List<TaskEntity> result = List.from(tasks);

    // Filter
    if (filter == TaskFilter.pending) {
      result = result.where((t) => !t.isCompleted).toList();
    } else if (filter == TaskFilter.completed) {
      result = result.where((t) => t.isCompleted).toList();
    }

    // Sort
    if (sort == TaskSort.byStatus) {
      result.sort((a, b) {
        if (a.isCompleted == b.isCompleted) {
          return a.createdAt.compareTo(b.createdAt);
        }
        return a.isCompleted ? 1 : -1;
      });
    } else {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }

    return result;
  }

  TasksState copyWith({
    List<TaskEntity>? tasks,
    bool? isLoading,
    String? error,
    TaskFilter? filter,
    TaskSort? sort,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      filter: filter ?? this.filter,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [tasks, isLoading, error, filter, sort];
}
