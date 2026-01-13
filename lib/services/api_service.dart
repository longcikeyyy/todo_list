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
      debugPrint('API Method: GET $_baseUrl');
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

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

  /// Create a new task via the API
  Future<List<Task>> createTask() async {
    final response = await http.get(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
      headers: {
        'Content-Type': 'application/json',
        'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
        'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  /// Update an existing task via the API
  Future<List<Task>> updateTask() async {
    final response = await http.get(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
      headers: {
        'Content-Type': 'application/json',
        'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
        'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  //// Delete a task via the API
  Future<List<Task>> deleteTask() async {
    final response = await http.get(
      Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
      headers: {
        'Content-Type': 'application/json',
        'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
        'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['data'];
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
