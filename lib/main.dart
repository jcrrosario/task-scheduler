import 'package:flutter/material.dart';
import 'package:task_scheduler/core/theme/app_theme.dart';
import 'package:task_scheduler/pages/auth/login_page.dart';

void main() {
  runApp(const TaskSchedulerApp());
}

class TaskSchedulerApp extends StatelessWidget {
  const TaskSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskScheduler',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
    );
  }
}