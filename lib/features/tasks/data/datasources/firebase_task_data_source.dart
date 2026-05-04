import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/task_entity.dart';
import '../models/task_model.dart';

class FirebaseTaskDataSource {
  final FirebaseFirestore _db;
  FirebaseTaskDataSource(this._db);

  Stream<List<TaskModel>> getTasks(String listId) {
    return _db
        .collection('tasks')
        .where('listId', isEqualTo: listId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((s) => s.docs.map(TaskModel.fromFireStore).toList());
  }

  Future<TaskModel> createTask(
    String listId,
    String title,
    String? description,
  ) async {
    final ref = await _db.collection('tasks').add({
      'listId': listId,
      'title': title,
      'description': description,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
    final doc = await ref.get();
    return TaskModel.fromFireStore(doc);
  }

  Future<void> updateTask(TaskModel task) =>
      _db.collection('tasks').doc(task.id).update({
        'title': task.title,
        'description': task.description,
        'status': task.status == TaskStatus.completed ? 'completed' : 'pending',
      });

  Future<void> deleteTask(String taskId) =>
      _db.collection('tasks').doc(taskId).delete();

  Future<void> toggleTask(String taskId, bool isCompleted) => _db
      .collection('tasks')
      .doc(taskId)
      .update({'status': isCompleted ? 'completed' : 'pending'});
}
