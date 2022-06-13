

import 'package:todoappflutter/data_provider/task_data.dart';
import 'package:todoappflutter/models/model.dart';

class TaskRepository {
  final TaskDataProvider taskDataProvider;

  TaskRepository({required this.taskDataProvider});

  Future<List<Task>> getAndSetTasks() async {
    return await taskDataProvider.getAndSetTasks();
  }

  Future<Task> getTask(int taskId) async {
    return await taskDataProvider.getTask(taskId);
  }

  Future<Task> postTask(Task task) async {
    return await taskDataProvider.postTask(task);
  }

  Future<Task> putTask(Task task) async {
    return await taskDataProvider.putTask(task);
  }

  Future<void> deleteTask(int id) async {
    return await taskDataProvider.deleteTask(id);
  }
}
