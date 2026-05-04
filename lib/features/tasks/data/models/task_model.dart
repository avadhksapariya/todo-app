import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.listId,
    required super.title,
    super.description,
    required super.status,
    required super.createdAt,
  });

  factory TaskModel.fromFireStore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      listId: data['listId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'],
      status: data['status'] == 'completed'
          ? TaskStatus.completed
          : TaskStatus.pending,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFireStore() => {
    'listId': listId,
    'title': title,
    'description': description,
    'status': status == TaskStatus.completed ? 'completed' : 'pending',
    'createdAt': Timestamp.fromDate(createdAt),
  };
}
