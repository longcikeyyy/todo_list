import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/services/api_service.dart';

class TaskRepository {
  final ApiService apiService = ApiService();

  Future<List<Task>> getAllTasks() async {
    return await apiService.getAllTasks();
  }
}
