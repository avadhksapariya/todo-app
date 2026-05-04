import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/list_model.dart';

class FirebaseListDataSource {
  final FirebaseFirestore _db;
  FirebaseListDataSource(this._db);

  Stream<List<TodoListModel>> getLists(String userId) {
    return _db
        .collection('lists')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((s) => s.docs.map(TodoListModel.fromFireStore).toList());
  }

  Future<TodoListModel> createList(String userId, String title) async {
    final ref = await _db.collection('lists').add({
      'userId': userId,
      'title': title,
      'createdAt': FieldValue.serverTimestamp(),
    });
    final doc = await ref.get();
    return TodoListModel.fromFireStore(doc);
  }

  Future<void> renameList(String listId, String title) =>
      _db.collection('lists').doc(listId).update({'title': title});

  Future<void> deleteList(String listId) async {
    // Delete all tasks in list first
    final tasks = await _db
        .collection('tasks')
        .where('listId', isEqualTo: listId)
        .get();
    final batch = _db.batch();
    for (final doc in tasks.docs) {
      batch.delete(doc.reference);
    }
    batch.delete(_db.collection('lists').doc(listId));
    await batch.commit();
  }
}
