import '../entities/todo_list_entity.dart';

abstract class TodoListRepository {
  Stream<List<TodoListEntity>> getLists(String userId);
  Future<TodoListEntity> createList(String userId, String title);
  Future<void> renameList(String listId, String newTitle);
  Future<void> deleteList(String listId);
}
