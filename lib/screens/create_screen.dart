import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/app_appbar.dart';
import 'package:todo_list/component/app_button.dart';
import 'package:todo_list/component/app_textfield.dart';
import 'package:todo_list/constant/app_color.dart';
import 'package:todo_list/constant/app_textstyle.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/providers/task_provider.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    super.dispose();
  }

  Future<void> onAddTask() async {
    final title = titleController.text.trim();
    final detail = detailController.text.trim();

    if (title.isEmpty || detail.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final task = Task(title: title, description: detail, status: 'pendiente');

    final provider = context.read<TaskProvider>();

    final success = await provider.createTask(task);

    if (!mounted) return;

    if (success) {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColor.backgroundColor,
          content: Text(
            textAlign: TextAlign.center,
            ' Create Task Succesfully ',
            style: AppTextstyle.tsJostSemiBoldSize24White,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('OK', style: AppTextstyle.tsJostSemiBoldSize13Purple),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(provider.errorMessage)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppAppbar(title: 'Add Task'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 43),
                height: 200,
                width: (356 / 414) * MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    AppTextfield(hintText: "Title", controller: titleController),
                    SizedBox(height: 40),
                    AppTextfield(
                      hintText: "Detail",
                      controller: detailController,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            AppButton(textButton: "ADD", onTap: onAddTask,width:MediaQuery.of(context).size.width - 14 - 14),
          ],
        ),
      ),
    );
  }
}
