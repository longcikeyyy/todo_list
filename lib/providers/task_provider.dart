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

  /// Initialize repository and storage service
  Future<void> init() async {
    await _taskRepository.init();
  }

  //get all task list
  Future<void> getAllTasks() async {
    try {
      _isLoading = true;
      notifyListeners();

      _tasks = await _taskRepository.getAllTasks();

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load tasks: $e';
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///handel togle complete task
  Future<void> toggleTask(Task task) async {
    try {
      final updatedTask = await _taskRepository.toggleTask(task);

      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to toggle tasks: $e';
      notifyListeners();
    }
  }

  //create new task
  Future<bool> createTask(Task task) async {
    _isLoading = true;
    notifyListeners();
    try {
      final createdTask = await _taskRepository.createTask(task);
      _tasks.add(createdTask);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //delete task
  Future<void> deleteTask(String taskId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _taskRepository.deleteTask(taskId);

      _tasks.removeWhere((task) => task.id == taskId);
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error while deleting task: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editTask({required Task task}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      await _taskRepository.editTask(task: task);

      // await getAllTasks();
      final index = _tasks.indexWhere((e) => e.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error while editing task: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
