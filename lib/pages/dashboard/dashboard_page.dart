import 'package:flutter/material.dart';
import 'package:task_scheduler/core/constants/app_colors.dart';
import 'package:task_scheduler/models/dashboard_summary.dart';
import 'package:task_scheduler/repositories/dashboard_repository.dart';
import 'package:task_scheduler/widgets/app_scaffold.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardRepository _repository = DashboardRepository();

  DashboardSummary? _summary;
  List<int> _availableYears = <int>[];

  bool _isLoading = true;
  int? _selectedMonth;
  int? _selectedYear;

  final Map<int, String> _months = const <int, String>{
    1: 'Janeiro',
    2: 'Fevereiro',
    3: 'Março',
    4: 'Abril',
    5: 'Maio',
    6: 'Junho',
    7: 'Julho',
    8: 'Agosto',
    9: 'Setembro',
    10: 'Outubro',
    11: 'Novembro',
    12: 'Dezembro',
  };

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() {
      _isLoading = true;
    });

    final List<int> years = await _repository.getAvailableYears();
    final DashboardSummary summary = await _repository.getSummary(
      month: _selectedMonth,
      year: _selectedYear,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _availableYears = years;
      _summary = summary;
      _isLoading = false;
    });
  }

  Future<void> _changeMonth(int? month) async {
    setState(() {
      _selectedMonth = month;
    });

    await _loadDashboard();
  }

  Future<void> _changeYear(int? year) async {
    setState(() {
      _selectedYear = year;
    });

    await _loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Dashboard',
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _loadDashboard,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              Text(
                'Dashboard',
                style:
                Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Resumo atual das tarefas cadastradas no aplicativo.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int?>(
                initialValue: _selectedMonth,
                decoration: const InputDecoration(
                  labelText: 'Mês',
                ),
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todos os meses'),
                  ),
                  ..._months.entries.map(
                        (entry) => DropdownMenuItem<int?>(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                  ),
                ],
                onChanged: (int? value) async {
                  await _changeMonth(value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: _selectedYear,
                decoration: const InputDecoration(
                  labelText: 'Ano',
                ),
                items: <DropdownMenuItem<int?>>[
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Todos os anos'),
                  ),
                  ..._availableYears.map(
                        (year) => DropdownMenuItem<int?>(
                      value: year,
                      child: Text(year.toString()),
                    ),
                  ),
                ],
                onChanged: (int? value) async {
                  await _changeYear(value);
                },
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (
                    BuildContext context,
                    BoxConstraints constraints,
                    ) {
                  const double spacing = 12;
                  int cardsPerRow = 2;

                  if (constraints.maxWidth >= 900) {
                    cardsPerRow = 3;
                  }

                  final double cardWidth =
                      (constraints.maxWidth - (spacing * (cardsPerRow - 1))) /
                          cardsPerRow;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: <Widget>[
                      SizedBox(
                        width: cardWidth,
                        child: _DashboardStatCard(
                          title: 'Total de tarefas',
                          value: '${_summary?.totalTasks ?? 0}',
                          icon: Icons.list_alt_outlined,
                          backgroundColor: const Color(0xFFE8F3FF),
                          iconBackgroundColor: const Color(0xFFD5E9FF),
                          iconColor: const Color(0xFF1565C0),
                          valueColor: const Color(0xFF0D47A1),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _DashboardStatCard(
                          title: 'Pendentes',
                          value: '${_summary?.pendingTasks ?? 0}',
                          icon: Icons.pending_actions_outlined,
                          backgroundColor: const Color(0xFFFFF4E5),
                          iconBackgroundColor: const Color(0xFFFFE3BF),
                          iconColor: const Color(0xFFEF6C00),
                          valueColor: const Color(0xFFE65100),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _DashboardStatCard(
                          title: 'Em andamento',
                          value: '${_summary?.inProgressTasks ?? 0}',
                          icon: Icons.autorenew_outlined,
                          backgroundColor: const Color(0xFFEAF7EE),
                          iconBackgroundColor: const Color(0xFFD3F0DC),
                          iconColor: const Color(0xFF2E7D32),
                          valueColor: const Color(0xFF1B5E20),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _DashboardStatCard(
                          title: 'Concluídas',
                          value: '${_summary?.completedTasks ?? 0}',
                          icon: Icons.check_circle_outline,
                          backgroundColor: const Color(0xFFEEEAFE),
                          iconBackgroundColor: const Color(0xFFDDD1FD),
                          iconColor: const Color(0xFF6A1B9A),
                          valueColor: const Color(0xFF4A148C),
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _DashboardStatCard(
                          title: 'Horas produtivas',
                          value:
                          (_summary?.totalHours ?? 0).toStringAsFixed(2),
                          icon: Icons.schedule_outlined,
                          backgroundColor: const Color(0xFFE7F7F5),
                          iconBackgroundColor: const Color(0xFFD0F0EC),
                          iconColor: AppColors.primaryDark,
                          valueColor: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardStatCard extends StatelessWidget {
  const _DashboardStatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.valueColor,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      constraints: const BoxConstraints(minHeight: 150),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.black.withAlpha(10),
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 22,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: valueColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}