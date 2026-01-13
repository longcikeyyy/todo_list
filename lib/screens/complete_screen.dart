import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/task_provider.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: []),
      body: Consumer<TaskProvider>(
        builder: (_, taskProvider, __) {
          return ListView.builder(
            itemCount: taskProvider.completedTasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.completedTasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.description),
              );
            },
          );
        },
      ),
    );
  }
}
