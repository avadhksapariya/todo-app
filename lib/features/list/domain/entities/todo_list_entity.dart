// lib/domain/entities/todo_list_entity.dart
class TodoListEntity {
  final String id;
  final String userId;
  final String title;
  final DateTime createdAt;

  const TodoListEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.createdAt,
  });

  TodoListEntity copyWith({String? title}) {
    return TodoListEntity(
      id: id,
      userId: userId,
      title: title ?? this.title,
      createdAt: createdAt,
    );
  }
}
