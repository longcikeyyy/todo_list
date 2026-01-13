import 'package:flutter/material.dart';
import 'package:todo_list/screens/complete_screen.dart';
import 'package:todo_list/screens/main_screen.dart';

class AppRoutes {
  /// Define all routes in the application
  static const String mainScreen = '/mainScreen';
  static const String completeScreen = '/completeScreen';

  /// routes map
  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.mainScreen: (context) => MainScreen(),
    AppRoutes.completeScreen: (context) => const CompleteScreen(),
  };
}
