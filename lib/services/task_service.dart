import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:todo_list/models/task_model.dart';

class TaskService{

Future<List<Task>> fetchTasks() async {
  final response = await http.get(
    Uri.parse('https://task-manager-api3.p.rapidapi.com/'),
    headers: {
      'Content-Type': 'application/json',
      'x-rapidapi-host': 'task-manager-api3.p.rapidapi.com',
      'x-rapidapi-key': '7d744c6ef6msh6295387dee9a9e0p1f763djsndf07a261252a'

    },
  );

  if (response.statusCode == 200) {
    final Map<String,dynamic> json = jsonDecode(response.body);
    final List<dynamic> data = json['data'];
    return data.map((e) => Task.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

}
