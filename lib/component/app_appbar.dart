import 'package:flutter/material.dart';
import 'package:todo_list/constant/app_color.dart';
import 'package:todo_list/constant/app_textstyle.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const AppAppbar({super.key, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColor.whiteColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: AppColor.purpleColor,
      title: Text(title, style: AppTextstyle.tsJostSemiBoldSize24White),
    );
  }
}
