import '../entities/task_entity.dart';

abstract class TaskRepository {
  Stream<List<TaskEntity>> getTasks(String listId);
  Future<TaskEntity> createTask(
    String listId,
    String title,
    String? description,
  );
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String taskId, String listId);
  Future<void> toggleTask(String taskId, String listId, bool isCompleted);
}
