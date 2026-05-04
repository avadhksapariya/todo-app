part of 'task_bloc.dart';

@immutable
sealed class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class TasksSubscribed extends TaskEvent {
  final String listId;
  const TasksSubscribed(this.listId);
  @override
  List<Object?> get props => [listId];
}

class TaskCreated extends TaskEvent {
  final String listId;
  final String title;
  final String? description;
  const TaskCreated(this.listId, this.title, this.description);
  @override
  List<Object?> get props => [listId, title, description];
}

class TaskUpdated extends TaskEvent {
  final TaskEntity task;
  const TaskUpdated(this.task);
  @override
  List<Object?> get props => [task];
}

class TaskDeleted extends TaskEvent {
  final String taskId;
  final String listId;
  const TaskDeleted(this.taskId, this.listId);
  @override
  List<Object?> get props => [taskId, listId];
}

class TaskToggled extends TaskEvent {
  final String taskId;
  final String listId;
  final bool isCompleted;
  const TaskToggled(this.taskId, this.listId, this.isCompleted);
  @override
  List<Object?> get props => [taskId, listId, isCompleted];
}

class TaskFilterChanged extends TaskEvent {
  final TaskFilter filter;
  const TaskFilterChanged(this.filter);
  @override
  List<Object?> get props => [filter];
}

class TaskSortChanged extends TaskEvent {
  final TaskSort sort;
  const TaskSortChanged(this.sort);
  @override
  List<Object?> get props => [sort];
}

class _TasksUpdated extends TaskEvent {
  final dynamic tasks;
  const _TasksUpdated(this.tasks);
}
