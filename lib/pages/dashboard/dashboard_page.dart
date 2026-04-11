import 'package:flutter/material.dart';
import 'package:task_scheduler/core/constants/app_strings.dart';
import 'package:task_scheduler/widgets/app_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: AppStrings.dashboardTitle,
      body: _DashboardBody(),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Dashboard inicial do TaskScheduler',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}