import 'package:flutter/material.dart';
import 'package:todo_list/constant/app_color.dart';
import 'package:todo_list/constant/app_textstyle.dart';

class AppTextfield extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  

  const AppTextfield({super.key, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller:controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
        hintStyle: AppTextstyle.tsJostRegularSize16Grey,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColor.blackColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColor.blackColor),
        ),
      ),
    );
  }
}
