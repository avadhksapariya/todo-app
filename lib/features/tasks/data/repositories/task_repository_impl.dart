import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/firebase_task_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final FirebaseTaskDataSource _dataSource;
  TaskRepositoryImpl(this._dataSource);

  @override
  Stream<List<TaskEntity>> getTasks(String listId) =>
      _dataSource.getTasks(listId);

  @override
  Future<TaskEntity> createTask(
    String listId,
    String title,
    String? description,
  ) => _dataSource.createTask(listId, title, description);

  @override
  Future<void> updateTask(TaskEntity task) {
    final model = TaskModel(
      id: task.id,
      listId: task.listId,
      title: task.title,
      description: task.description,
      status: task.status,
      createdAt: task.createdAt,
    );
    return _dataSource.updateTask(model);
  }

  @override
  Future<void> deleteTask(String taskId, String listId) =>
      _dataSource.deleteTask(taskId);

  @override
  Future<void> toggleTask(String taskId, String listId, bool isCompleted) =>
      _dataSource.toggleTask(taskId, isCompleted);
}
