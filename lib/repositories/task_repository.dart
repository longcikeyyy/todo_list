import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/services/api_service.dart';
import 'package:todo_list/services/storage_service.dart';

class TaskRepository {
  final ApiService apiService = ApiService();
  final StorageService storageService = StorageService();
  final Connectivity _connectivity = Connectivity();

  /// initialize storage service
  Future<void> init() async {
    await storageService.init();
    _setupConnectivityListener();
  }

  /// Synchronize local storage with remote API
  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) async {
      if (result.contains(ConnectivityResult.none)) {
        debugPrint('Offline mode: No internet connection.');

        /// Do something when offline
      } else {
        debugPrint('Online mode: Internet connection restored.');

        /// If online, do something when online
        /// sync local changes to server
      }
    });
  }

  //get all tassk
  Future<List<Task>> getAllTasks() async {
    try {
      if (await isOnline()) {
        /// fetch from API
        final allTasks = await apiService.getAllTasks();
        await storageService.saveAllTasks(allTasks);
        return allTasks;
      } else {
        /// fetch from local storage
        final localTasks = await storageService.getAllTasks();
        return localTasks;
      }
    } catch (e) {
      debugPrint('Error fetching tasks from repository: $e');
      throw Exception('Failed to load tasks: $e');
    }
  }

  //update complete task
  Future<Task> toggleTask(Task task) async {
    try {
      final newStatus = task.isCompleted ? 'pendiente' : 'completada';
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        status: newStatus,
      );
      await apiService.updateTask(task: updatedTask);
      return updatedTask;
    } catch (e) {
      debugPrint('Error toggling task in repository: $e');
      throw Exception('Toggle failed: $e');
    }
  }

  //create task
  Future<Task> createTask(Task task) async {
    try {
      final newStatus = 'pendiente';
      final updatedTask = Task(
        id: task.id,
        title: task.title,
        description: task.description,
        status: newStatus,
      );
      await apiService.createTask(task: updatedTask);
      return updatedTask;
    } catch (e) {
      debugPrint('Error creating task in repository: $e');
      throw Exception('Create failed: $e');
    }
  }

  //delete task
  Future<void> deleteTask(String taskId) async {
    try {
      if (await isOnline()) {
        await apiService.deleteTask(taskId);
      } else {
        await storageService.deleteTask(taskId);
      }
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  //edit task
  Future<void> editTask({required Task task}) async {
    try {
      await apiService.updateTask(task: task);
    } catch (e) {
      debugPrint('Error updating task in repository: $e');
      throw Exception('Update failed: $e');
    }
  }

  /// check connectivity -> isOnline or not
  Future<bool> isOnline() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      return false;
    }
  }
}
