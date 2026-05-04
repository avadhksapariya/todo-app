import '../../domain/entities/todo_list_entity.dart';
import '../../domain/repositories/list_repository.dart';
import '../datasources/firebase_list_data_source.dart';

class TodoListRepositoryImpl implements TodoListRepository {
  final FirebaseListDataSource _dataSource;
  TodoListRepositoryImpl(this._dataSource);

  @override
  Stream<List<TodoListEntity>> getLists(String userId) =>
      _dataSource.getLists(userId);

  @override
  Future<TodoListEntity> createList(String userId, String title) =>
      _dataSource.createList(userId, title);

  @override
  Future<void> renameList(String listId, String newTitle) =>
      _dataSource.renameList(listId, newTitle);

  @override
  Future<void> deleteList(String listId) => _dataSource.deleteList(listId);
}
