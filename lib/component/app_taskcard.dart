import 'package:flutter/material.dart';
import 'package:todo_list/constant/app_color.dart';
import 'package:todo_list/constant/app_textstyle.dart';
import 'package:todo_list/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    this.onEdit,
    this.onDelete,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 7, right: 11, bottom: 10),
      width: (400 / 414) * MediaQuery.of(context).size.width,
      height: (82 / 896) * MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColor.blackColor.withValues(alpha: 0.25),
            blurRadius: 4,
            spreadRadius: 0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 19, right: 25),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    task.title,
                    style: AppTextstyle.tsJostSemiBoldSize13Purple,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    task.description,
                    style: AppTextstyle.tsJostRegularSize10Black,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    color: AppColor.iconColor,
                  ),

                // Delete button
                if (onEdit != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline),
                    color: AppColor.iconColor,
                  ),

                // Complete button
                IconButton(
                  onPressed: onComplete,
                  icon: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                  ),
                  color: task.isCompleted ? Colors.green : AppColor.iconColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
