import 'package:flutter/material.dart';
import 'package:task_scheduler/core/constants/app_colors.dart';
import 'package:task_scheduler/core/constants/app_strings.dart';
import 'package:task_scheduler/pages/auth/login_page.dart';
import 'package:task_scheduler/pages/clients/clients_page.dart';
import 'package:task_scheduler/pages/consultancy/consultancy_page.dart';
import 'package:task_scheduler/pages/dashboard/dashboard_page.dart';
import 'package:task_scheduler/pages/reports/reports_page.dart';
import 'package:task_scheduler/pages/tasks/tasks_page.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.appName),
      ),
      drawer: const _AppDrawer(),
      body: body,
    );
  }
}

class _AppDrawer extends StatelessWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            const _DrawerHeader(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  _DrawerItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.list_alt_outlined,
                    label: 'Tarefas',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const TasksPage(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.people_outline,
                    label: 'Clientes/Projetos',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const ClientsPage(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.assessment_outlined,
                    label: 'Relatórios',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const ReportsPage(),
                        ),
                      );
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Consultoria',
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (_) => const ConsultancyPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24),
            _DrawerItem(
              icon: Icons.logout,
              label: 'Sair',
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute<void>(
                    builder: (_) => const LoginPage(),
                  ),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.centerLeft,
      child: const Row(
        children: <Widget>[
          Icon(
            Icons.calendar_month_rounded,
            color: Colors.white,
            size: 32,
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Task Scheduler',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Principia Consultoria',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
    );
  }
}