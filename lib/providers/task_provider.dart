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
      throw Exception(e.toString());
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
    _errorMessage = 'null';
    notifyListeners();

    try {
      final success = await _taskRepository.deleteTask(taskId);
      
      if (success) {
        
        _errorMessage = '';
      } else {
        _errorMessage = 'Can not delete';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


   Future<bool> updateTask(Task updatedTask, {
    required Task task,
    required String newStatus,
  }) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final success = await _taskRepository.updateTask(
        task: task,
        newStatus: newStatus,
      );
      
      if (success) {
        
        await getAllTasks();
        _errorMessage = '';
        return true;
      } else {
        _errorMessage = 'Can not update task';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
