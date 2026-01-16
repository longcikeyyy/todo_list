import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/services/api_service.dart';

class TaskRepository {
  final ApiService apiService = ApiService();

  Future<List<Task>> getAllTasks() async {
    return await apiService.getAllTasks();
  }

  Future<Task> toggleTask(Task task) async {
    if (task.id == null) {
      throw Exception('Task id is null');
    }
    final newStatus = task.isCompleted ? 'pendiente' : 'completada';
    await apiService.updateTask(task: task, newStatus: newStatus);
    return Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: newStatus,
    );
  }

  Future<Task> createTask(Task task) async {
    final newStatus = 'pendiente';
    await apiService.createTask(task: task);
    return Task(
      id: task.id,
      title: task.title,
      description: task.description,
      status: newStatus,
    );
  }
}
