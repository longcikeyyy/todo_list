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
      if (!result.contains(ConnectivityResult.none)) {
        debugPrint('Online mode: Internet connection restored.');

        /// If online, do something when online
        /// sync local changes to server
        try {
          /// sync pending operations to server
          await _syncPendingOperationsToServer();

          /// Refresh data from server
          /// fetch from API
          final allTasks = await apiService.getAllTasks();

          /// save tasks to local storage
          await storageService.saveAllTasks(allTasks);
        } catch (e) {
          debugPrint('Error syncing local changes to server: $e');
          throw Exception('Failed to sync local changes to server: $e');
        }
      } else {
        debugPrint('Offline mode: No internet connection.');
      }
    });
  }

  Future<void> _syncPendingOperationsToServer() async {
    debugPrint('Syncing pending operations to server...');

    /// get all sync queue items
    final syncQueueItems = await storageService.getAllSyncBoxTask();

    /// if empty -> do nothing
    if (syncQueueItems.isEmpty) return;

    debugPrint(
      'Syncing ${syncQueueItems.length} pending operations to server...',
    );

    /// Sync single operation to server
    for (var item in syncQueueItems) {
      try {
        final operation = item['operation'] as String;
        final taskJson = Map<String, dynamic>.from(item['task'] as Map);
        final task = Task.fromJson(taskJson);

        final String originalTaskId = task.id!;

        if (operation == 'create') {
          /// create task on server
          await apiService.createTask(task: task);

          /// delete operation from sync queue box
          await storageService.deleteASyncBoxTask(originalTaskId);

          /// save task to local storage
          await storageService.saveTask(task);

          debugPrint('Task ${task.id} created successfully');
        } else if (operation == 'update') {
          /// update task on server
          await apiService.updateTask(task: task);

          /// delete operation from sync queue box
          await storageService.deleteASyncBoxTask(originalTaskId);

          /// save task to local storage
          await storageService.updateTask(task);

          debugPrint('Task ${task.id} updated successfully');
        } else if (operation == 'delete') {
          /// delete task on server
          await apiService.deleteTask(originalTaskId);

          /// delete operation from sync queue box
          await storageService.deleteASyncBoxTask(originalTaskId);

          /// delete task from local storage
          await storageService.deleteTask(originalTaskId);

          debugPrint('Task ${task.id} deleted successfully');
        } else {
          debugPrint('Invalid operation: $operation');
          throw Exception('Invalid operation: $operation');
        }
      } catch (e) {
        debugPrint('Error syncing single operation to server: $e');
        throw Exception('Failed to sync single operation to server: $e');
      }
    }
  }

  //get all tassk
  Future<List<Task>> getAllTasks() async {
    try {
      if (await isOnline()) {
        /// fetch from API
        final allTasks = await apiService.getAllTasks();

        /// save tasks to local storage
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

      if (await isOnline()) {
        /// update task on server
        await apiService.updateTask(task: updatedTask);

        /// save task to local storage
        await storageService.updateTask(updatedTask);
        return updatedTask;
      } else {
        /// add task to sync queue box
        await storageService.addATaskToSyncBox(
          task: updatedTask,
          operation: 'update',
        );

        /// save task to local storage
        await storageService.updateTask(updatedTask);

        return updatedTask;
      }
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
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: task.title,
        description: task.description,
        status: newStatus,
      );
      debugPrint('Creating task with ID: ${updatedTask.id}');
      if (await isOnline()) {
        /// create task on server
        await apiService.createTask(task: updatedTask);

        /// save task to local storage
        await storageService.saveTask(updatedTask);

        return updatedTask;
      } else {
        /// add task to sync queue box
        await storageService.addATaskToSyncBox(
          task: updatedTask,
          operation: 'create',
        );

        /// save task to local storage
        await storageService.saveTask(updatedTask);
        return updatedTask;
      }
    } catch (e) {
      debugPrint('Error creating task in repository: $e');
      throw Exception('Create failed: $e');
    }
  }

  //delete task
  Future<void> deleteTask(Task task) async {
    try {
      if (task.id == null || task.id!.isEmpty) {
        throw Exception('Task ID is required');
      }
      if (await isOnline()) {
        /// delete task on server
        await apiService.deleteTask(task.id!);

        /// delete task from local storage
        await storageService.deleteTask(task.id!);
      } else {
        /// add task to sync queue box
        await storageService.addATaskToSyncBox(task: task, operation: 'delete');

        /// delete task from local storage
        await storageService.deleteTask(task.id!);
      }
    } catch (e) {
      throw Exception('Delete failed: $e');
    }
  }

  //edit task
  Future<void> editTask({required Task task}) async {
    try {
      if (await isOnline()) {
        /// update task on server
        await apiService.updateTask(task: task);

        /// save task to local storage
        await storageService.updateTask(task);
      } else {
        /// add task to sync queue box
        await storageService.addATaskToSyncBox(task: task, operation: 'update');

        /// save task to local storage
        await storageService.updateTask(task);
      }
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
