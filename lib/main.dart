import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/providers/demo_provider.dart';
import 'package:todo_list/routes/app_routes.dart';
import 'package:todo_list/screens/demo_screen.dart';
import 'package:todo_list/providers/task_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskProvider()),
        ChangeNotifierProvider(create: (context) => DemoProvider()),
      ],
      child: MyApp(),
    ),
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
      // home: const DemoScreen(),
    );
  }
}
