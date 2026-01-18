import 'package:flutter/material.dart';
import 'package:todo_list/constant/app_color.dart';

import 'package:todo_list/constant/app_textstyle.dart';

class AppButton extends StatelessWidget {
  final String textButton;
  final Function()? onTap;
  final double? width;
  

  const AppButton({super.key, required this.textButton, this.onTap,required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 66,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColor.purpleColor,
          boxShadow: [
            BoxShadow(
              color: AppColor.blackColor.withValues(alpha: 0.25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          textButton,
          style: AppTextstyle.tsJostSemiBoldSize24White.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}
