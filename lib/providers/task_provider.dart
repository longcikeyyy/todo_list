import 'package:flutter/material.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/repositories/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  final TaskRepository _taskRepository = TaskRepository();

  /// define state variables
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  List<Task> _tasks = [];

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isCompleted).toList();

  List<Task> get pendingTasks =>
      _tasks.where((task) => task.isPending).toList();

  Future<void> getAllTasks() async {
    try {
      _isLoading = true;
      notifyListeners();

      _tasks = await _taskRepository.getAllTasks();
      debugPrint('Tasks count: ${_tasks.length}');
      debugPrint('Completed tasks: ${completedTasks.length}');
      debugPrint('Pending tasks: ${pendingTasks.length}');

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load tasks: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
