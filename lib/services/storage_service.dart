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
  Future<void> addTasksToSyncBox(Map<String, dynamic> valueTask) async {
    await _syncQueueBox.clear();
    final key = DateTime.now().microsecondsSinceEpoch.toString();
    //final valueTask = '';
    await _syncQueueBox.put(key, valueTask);
  }

  /// Get all Sync Queue Items
  Future<List<Map>> getAllSyncBoxTask() async {
    return _syncQueueBox.values.toList();
  }

  /// Clear all Sync Queue Box
  Future<void>deleteAllSyncBoxTasks(List<String> keys )async{
    await _syncQueueBox.deleteAll(keys);
  }
  /// Delete a specific Sync Queue Item
  Future<void> deleteSyncBoxTasks(String key) async {
    debugPrint('Deleting sync queue item with key: $key');
    await _syncQueueBox.delete(key);
  }
}
