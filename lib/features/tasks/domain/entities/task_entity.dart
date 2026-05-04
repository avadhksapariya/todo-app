enum TaskStatus { pending, completed }

class TaskEntity {
  final String id;
  final String listId;
  final String title;
  final String? description;
  final TaskStatus status;
  final DateTime createdAt;

  const TaskEntity({
    required this.id,
    required this.listId,
    required this.title,
    this.description,
    required this.status,
    required this.createdAt,
  });

  bool get isCompleted => status == TaskStatus.completed;

  TaskEntity copyWith({
    String? title,
    Object? description = const _Unset(),
    TaskStatus? status,
  }) {
    return TaskEntity(
      id: id,
      listId: listId,
      title: title ?? this.title,
      description: description is _Unset
          ? this.description
          : description as String?,
      status: status ?? this.status,
      createdAt: createdAt,
    );
  }
}

class _Unset {
  const _Unset();
}
