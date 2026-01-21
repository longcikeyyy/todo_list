import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:todo_list/models/task_model.dart';

class StorageService {
  static const String _taskBoxName = 'tasksBox';
  static const String _syncQueueBoxName = 'syncQueueBox';

  /// We have 2 boxes:
  /// 1. tasksBox: to store tasks locally
  /// 2. syncQueueBox: to store operations that need to be synced with the server
  late Box<Task> _taskBox;
  late Box<Map> _syncQueueBox;

  /// initialize Hive boxes
  Future<void> init() async {
    debugPrint('Initializing Hive boxes...');
    _taskBox = await Hive.openBox<Task>(_taskBoxName);
    _syncQueueBox = await Hive.openBox<Map>(_syncQueueBoxName);
    debugPrint('Hive boxes initialized successfully.');
  }

  /// Functions to interact with tasksBox, syncQueueBox

  /// Get all tasks from local storage
  Future<List<Task>> getAllTasks() async {
    debugPrint('Fetching all tasks from local storage...');
    debugPrint('Total tasks found: ${_taskBox.length}');
    return _taskBox.values.toList();
  }

  /// Save All Tasks to local storage
  Future<void> saveAllTasks(List<Task> tasks) async {
    debugPrint('Saving all tasks to local storage...');
    await _taskBox.clear();
    for (var task in tasks) {
      await _taskBox.put(task.id, task);
    }
    debugPrint('All tasks saved successfully.');
    debugPrint('Total tasks saved: ${_taskBox.length}');
  }

  /// Save a single task to local storage
  Future<void> saveTask(Task task) async {
    debugPrint('Saving task with ID: ${task.id} to local storage...');
    final key = task.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    await _taskBox.put(key, task);
    debugPrint('Task saved successfully.');
  }

  /// Delete a task from local storage
  Future<void> deleteTask(String id) async {
    debugPrint('Deleting task with ID: $id from local storage...');
    await _taskBox.delete(id);
    debugPrint('Task deleted successfully.');
  }

  /// Update a task in local storage
  Future<void> updateTask(Task task) async {
    debugPrint('Updating task with ID: ${task.id} in local storage...');
    await _taskBox.put(task.id, task);
    debugPrint('Task updated successfully.');
  }

  /// Sync Queue Operations Logic _syncQueueBox

  /// Add Task to Sync Queue Box
  /// Operation: Create, Update, Delete
  Future<void> addATaskToSyncBox({
    required Task task,
    required String operation,
  }) async {
    Task ensureTask = task;
    if (task.id == null || task.id!.isEmpty) {
      final String generatedId = DateTime.now().microsecondsSinceEpoch
          .toString();
      ensureTask = Task(
        id: generatedId,
        title: task.title,
        description: task.description,
        status: task.status,
      );
    }
    final Map<dynamic, dynamic> data;

    /// LOCAL LOGIC:
    /// check operation
    /// CREATE -> CREATE -> POST
    /// UPDATE -> UPDATE -> PUT
    /// DELETE -> DELETE -> DELETE
    ///
    /// CREATE + UPDATE -> CREATE -> POST
    /// CREATE + DELETE -> no need to sync
    /// UPDATE + DELETE -> DELETE -> DELETE
    /// Get existing task from sync queue box -> get its operation
    final Map<dynamic, dynamic>? existingTaskInfo = _syncQueueBox.get(
      ensureTask.id,
    );
    if (existingTaskInfo != null) {
      /// Existing task in sync queue box -> get its operation
      final String? operationExistingTask =
          existingTaskInfo['operation'] as String?;

      if (operation == 'update' && operationExistingTask == 'create') {
        data = {'task': ensureTask.toJson(), 'operation': 'create'};
      } else if (operation == 'delete' && operationExistingTask == 'create') {
        _syncQueueBox.delete(ensureTask.id);
        debugPrint(
          'Task ${ensureTask.id} is already in sync queue box with operation create -> no need to sync',
        );
        return;
      } else {
        data = {'task': ensureTask.toJson(), 'operation': operation};
      }
      await _syncQueueBox.put(ensureTask.id, data);
      debugPrint('Sync queue box length: ${_syncQueueBox.length}');
    } else {
      /// Never save this task to sync queue box before -> no existing task before
      data = {'task': ensureTask.toJson(), 'operation': operation};
      await _syncQueueBox.put(ensureTask.id, data);
      debugPrint('Sync queue box length: ${_syncQueueBox.length}');
    }
  }

  /// Get all Sync Queue Items
  Future<List<Map>> getAllSyncBoxTask() async {
    debugPrint('Fetching all sync queue items from local storage...');
    debugPrint('Total sync queue items found: ${_syncQueueBox.length}');
    return _syncQueueBox.values.toList();
  }

  /// Clear all Sync Queue Box
  Future<void> deleteAllSyncBoxTasks() async {
    await _syncQueueBox.clear();
    debugPrint('All sync queue items deleted successfully.');
  }

  /// Delete a specific Sync Queue Item
  Future<void> deleteASyncBoxTask(String key) async {
    debugPrint('Deleting sync queue item with key: $key');
    await _syncQueueBox.delete(key);
    debugPrint('Deleted sync queue item successfully.');
  }
}
