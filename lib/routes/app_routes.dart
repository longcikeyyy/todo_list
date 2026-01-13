import 'package:flutter/material.dart';
import 'package:todo_list/screens/main_screen.dart';

class AppRoutes {
  /// Define all routes in the application
  static const String mainScreen = '/mainScreen';

  /// routes map
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.mainScreen: (context) => MainScreen(),
  };
}
