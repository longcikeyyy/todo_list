import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/models/task_model.dart';
import 'package:todo_list/routes/app_routes.dart';
import 'package:todo_list/providers/task_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Init Hive
  await Hive.initFlutter();

  /// init Adapter
  Hive.registerAdapter(TaskAdapter());

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => TaskProvider())],
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
