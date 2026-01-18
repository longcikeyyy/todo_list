import 'package:flutter/material.dart';
import 'package:todo_list/constant/app_color.dart';

class AppTextstyle {
  /// Regular -> 400
  /// Medium -> 500
  /// Semi-Bold -> 600
  /// Extra Bold -> 800

  static String fontFamily = 'Jost';

  static TextStyle tsJostSemiBoldSize24White = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColor.whiteColor,
  );
  static TextStyle tsJostSemiBoldSize13Purple = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColor.purpleColor,
  );
  static TextStyle tsJostRegularSize10Black = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColor.blackColor,
  );
  static TextStyle tsJostRegularSize16Grey = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColor.hintTextColor,
  );
}
