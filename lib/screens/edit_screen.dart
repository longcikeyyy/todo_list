import 'package:flutter/material.dart';
import 'package:todo_list/component/app_appbar.dart';
import 'package:todo_list/component/app_button.dart';
import 'package:todo_list/component/app_textfield.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 40),
                  AppTextfield(
                    hintText: 'Detail',
                    controller: TextEditingController(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          AppButton(textButton: "ADD"),
        ],
      ),
    );
  }
}
