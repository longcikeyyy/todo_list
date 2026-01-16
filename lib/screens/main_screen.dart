import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/constant/app_textstyle.dart';
import 'package:todo_list/providers/task_provider.dart';
import 'package:todo_list/component/app_taskcard.dart';
import 'package:todo_list/constant/app_color.dart';
import 'package:todo_list/routes/app_routes.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
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

      body: RefreshIndicator(
        onRefresh: () => context.read<TaskProvider>().getAllTasks(),
        child: Consumer<TaskProvider>(
          builder: (_, provider, __) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage.isNotEmpty) {
              return Center(child: Text(provider.errorMessage));
            }

            if (provider.pendingTasks.isEmpty) {
              return const Center(child: Text('No tasks\nAdd your tasks now!'));
            }

            return ListView.separated(
              padding: const EdgeInsets.only(top: 22),
              itemCount: provider.pendingTasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final task = provider.pendingTasks[index];
                return TaskCard(
                  task: task,
                  onEdit: () {},
                  onDelete: () {},
                  onComplete: () async {
                    try {
                      await context.read<TaskProvider>().toggleTask(task);
                    } catch (e) {
                      if (!context.mounted) return;
                      await showDialog<void>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          backgroundColor: AppColor.backgroundColor,
                          content: Text(
                            textAlign: TextAlign.center,
                            'Can not update',
                            style: AppTextstyle.tsJostSemiBoldSize24White,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(dialogContext).pop(),
                              child: Text(
                                'OK',
                                style: AppTextstyle.tsJostSemiBoldSize13Purple,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, AppRoutes.completeScreen);
          }
        },
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
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.createScreen);
          },
        ),
      ),
    );
  }
}
