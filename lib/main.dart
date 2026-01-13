import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/routes/app_routes.dart';
import 'package:todo_list/services/task_provider.dart';


void main() {
  runApp(ChangeNotifierProvider(
    create:(_) => TaskProvider(),
    child: const MyApp()
    )
    );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.mainScreen,
      routes: AppRoutes.routes,
    );
  }
}


