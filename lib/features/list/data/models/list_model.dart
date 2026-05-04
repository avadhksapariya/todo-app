import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/todo_list_entity.dart';

class TodoListModel extends TodoListEntity {
  const TodoListModel({
    required super.id,
    required super.userId,
    required super.title,
    required super.createdAt,
  });

  factory TodoListModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TodoListModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFireStore() => {
    'userId': userId,
    'title': title,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
