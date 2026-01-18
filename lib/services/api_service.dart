import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list/models/task_model.dart';

class ApiService {
  final String _baseUrl = 'https://task-manager-api3.p.rapidapi.com/';
  static final String _rapidApiHost = 'task-manager-api3.p.rapidapi.com';
  static final String _rapidApiKey =
      '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a';

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'x-rapidapi-host': _rapidApiHost,
    'x-rapidapi-key': _rapidApiKey,
  };

  /// Get all tasks from the API
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final List<dynamic> data = json['data'];
        return data
            .map((e) => Task.fromJson(e))
            .where((task) => task.id != null && task.id!.isNotEmpty)
            .toList();
      } else {
        debugPrint('No tasks found. Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
      throw Exception('Failed to load data: $e');
    }
  }

  /// Update an existing task via the API
  Future<void> updateTask({required Task task}) async {
    try {
      final url = '$_baseUrl${task.id}';

      final body = jsonEncode(task.toUpdateJson());

      final response = await http.put(
        Uri.parse(url),
        headers: _headers,
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Update failed: ${response.body}');
      }
      debugPrint('✓ Task updated successfully');
    } catch (e) {
      debugPrint('Error updating task: $e');
      throw Exception('Update failed: $e');
    }
  }

  ///create task
  Future<void> createTask({required Task task}) async {
    try {
      final url = _baseUrl;
      final body = jsonEncode(task.toUpdateJson());
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: body,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Update failed: ${response.body}');
      }
      debugPrint(' Task create successfully');
    } catch (e) {
      debugPrint('Error creating task: $e');
      throw Exception('Create failed: $e');
    }
  }

  //delete task
  Future<void> deleteTask(String taskId) async {
    try {
      final url = '$_baseUrl$taskId';
      final response = await http.delete(Uri.parse(url), headers: _headers);
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed Delete Task: ${response.body}');
      }
      debugPrint('Delete Task Successfully');
    } catch (e) {
      debugPrint('Error deleting task: $e');
      throw Exception('Delete failed: $e');
    }
  }
}
