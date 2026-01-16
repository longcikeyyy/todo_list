import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/app_appbar.dart';
import 'package:todo_list/component/app_taskcard.dart';
import 'package:todo_list/providers/task_provider.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar(title: 'Completed Task'),
      body: Consumer<TaskProvider>(
        builder: (_, taskProvider, __) {
          return ListView.separated(
            padding: const EdgeInsets.only(top: 22),
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: taskProvider.completedTasks.length,
            itemBuilder: (context, index) {
              final task = taskProvider.completedTasks[index];
              return TaskCard(
                task: task,
                onComplete: () {
                  context.read<TaskProvider>().toggleTask(task);
                },
              );
            },
          );
        },
      ),
    );
  }
}
