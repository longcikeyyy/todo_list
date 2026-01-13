
import 'package:flutter/material.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final TaskService _service = TaskService();

  List<Task> tasks = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchTasks() async {
    isLoading = true;
    notifyListeners();

    try {
      tasks = await _service.fetchTasks();
      debugPrint('Tasks count: ${tasks.length}');
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}

