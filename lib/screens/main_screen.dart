import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/constant/app_textstyle.dart';
import 'package:todo_list/services/task_provider.dart';
import 'package:todo_list/component/app_taskcard.dart';

import 'package:todo_list/constant/app_color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.purpleColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('TODO APP', style: AppTextstyle.tsJostSemiBoldSize24White),
            Icon(Icons.calendar_today, color: AppColor.whiteColor),
          ],
        ),
      ),

      body: Builder(
        builder: (_) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          if (provider.tasks.isEmpty) {
            return const Center(child: Text('No tasks'));
          }

          return ListView.separated(
            padding: const EdgeInsets.only(top: 22),
            itemCount: provider.tasks.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final task = provider.tasks[index];
              return TaskCard(
                task: task,
                onEdit: () {},
                onDelete: () {},
                onComplete: () {},
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
          BottomNavigationBarItem(icon: Icon(Icons.check), label: 'Complete'),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
          shape: BoxShape.circle,
          color: AppColor.purpleColor,
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: AppColor.whiteColor),
          onPressed: () {},
        ),
      ),
    );
  }
}
