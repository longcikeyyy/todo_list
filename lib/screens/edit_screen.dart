import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/component/app_appbar.dart';
import 'package:todo_list/component/app_button.dart';
import 'package:todo_list/component/app_textfield.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/providers/task_provider.dart';

class EditScreen extends StatefulWidget {
  final Task task; 
  const EditScreen({super.key,required this.task});

  @override
  State<EditScreen> createState() => _EditScreenState();

}


class _EditScreenState extends State<EditScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  @override
void initState() {
  super.initState();
  titleController.text = widget.task.title;
  detailController.text = widget.task.description;
}
 
    @override
  void dispose() {
    titleController.dispose();
    detailController.dispose();
    super.dispose();
  }
  Future<void> onUpdateTask() async {
  final title = titleController.text.trim();
  final detail = detailController.text.trim();

  if (title.isEmpty || detail.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all fields')),
    );
    return;
  }

  final updatedTask = Task(
    id: widget.task.id,
    title: title,
    description: detail,
    status: widget.task.status,
  );

  final provider = context.read<TaskProvider>();
  final success = await provider.updatedTask(task: null, newStatus: '');
 

  if (!mounted) return;

  if (success) {
    Navigator.pop(context, true);
  } else {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(provider.errorMessage)));
  }
}
 


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppAppbar(title: "Edit Task"),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 43),
              height: 200,
              width: (356 / 414) * MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  AppTextfield(
                    hintText: 'Title',
                    controller: titleController,
                  ),
                  SizedBox(height: 40),
                  AppTextfield(
                    hintText: 'Detail',
                    controller: detailController,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
Row(
  mainAxisAlignment : MainAxisAlignment.center,
  children: [
    AppButton(
    onTap: onUpdateTask,
    textButton:"Update",width: 170,),
    SizedBox(width: 46),
    AppButton(
      onTap: () {
        Navigator.pop(context);
      },
      textButton:"Cancel",width: 170,),
  ],
)
          
        ],
      ),
    );
  }
}
