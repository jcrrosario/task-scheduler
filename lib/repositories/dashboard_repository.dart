import 'package:task_scheduler/models/dashboard_summary.dart';
import 'package:task_scheduler/repositories/task_repository.dart';

class DashboardRepository {
  DashboardRepository({TaskRepository? taskRepository})
      : _taskRepository = taskRepository ?? TaskRepository();

  final TaskRepository _taskRepository;

  Future<List<int>> getAvailableYears() async {
    final items = await _taskRepository.getAll();

    final Set<int> years = <int>{};

    for (final item in items) {
      years.add(item.task.date.year);
    }

    final List<int> sortedYears = years.toList()
      ..sort((a, b) => b.compareTo(a));

    return sortedYears;
  }

  Future<DashboardSummary> getSummary({
    int? month,
    int? year,
  }) async {
    final items = await _taskRepository.getAll();

    final filteredItems = items.where((item) {
      final DateTime taskDate = item.task.date;

      final bool matchesYear = year == null || taskDate.year == year;
      final bool matchesMonth = month == null || taskDate.month == month;

      return matchesYear && matchesMonth;
    }).toList();

    int totalTasks = filteredItems.length;
    int pendingTasks = 0;
    int inProgressTasks = 0;
    int completedTasks = 0;
    double completedHours = 0;
    double totalCompletedHoursValue = 0;

    for (final item in filteredItems) {
      final String status = item.task.status.trim().toLowerCase();

      if (status == 'pendente') {
        pendingTasks++;
      } else if (status == 'em andamento') {
        inProgressTasks++;
      } else if (status == 'concluído') {
        completedTasks++;
        completedHours += item.task.hours;
        totalCompletedHoursValue +=
            item.task.hours * item.task.clientHourlyRateSnapshot;
      }
    }

    final DateTime now = DateTime.now();
    final int baseYear = year ?? now.year;
    final int baseMonth = month ?? now.month;

    final _QuarterRange quarterRange = _resolveQuarterRange(
      month: baseMonth,
      year: baseYear,
    );

    final List<DashboardQuarterBar> quarterBars = _buildQuarterBars(
      items: items,
      year: quarterRange.year,
      startMonth: quarterRange.startMonth,
      endMonth: quarterRange.endMonth,
    );

    return DashboardSummary(
      totalTasks: totalTasks,
      pendingTasks: pendingTasks,
      inProgressTasks: inProgressTasks,
      completedTasks: completedTasks,
      completedHours: completedHours,
      totalCompletedHoursValue: totalCompletedHoursValue,
      quarterLabel: quarterRange.label,
      quarterBars: quarterBars,
    );
  }

  _QuarterRange _resolveQuarterRange({
    required int month,
    required int year,
  }) {
    if (month >= 1 && month <= 3) {
      return _QuarterRange(
        year: year,
        startMonth: 1,
        endMonth: 3,
        label: 'Q1/$year',
      );
    }

    if (month >= 4 && month <= 6) {
      return _QuarterRange(
        year: year,
        startMonth: 4,
        endMonth: 6,
        label: 'Q2/$year',
      );
    }

    if (month >= 7 && month <= 9) {
      return _QuarterRange(
        year: year,
        startMonth: 7,
        endMonth: 9,
        label: 'Q3/$year',
      );
    }

    return _QuarterRange(
      year: year,
      startMonth: 10,
      endMonth: 12,
      label: 'Q4/$year',
    );
  }

  List<DashboardQuarterBar> _buildQuarterBars({
    required List<dynamic> items,
    required int year,
    required int startMonth,
    required int endMonth,
  }) {
    final Map<int, double> totalsByMonth = <int, double>{
      for (int month = startMonth; month <= endMonth; month++) month: 0,
    };

    for (final item in items) {
      final DateTime taskDate = item.task.date;
      final String status = item.task.status.trim().toLowerCase();

      if (taskDate.year != year) {
        continue;
      }

      if (taskDate.month < startMonth || taskDate.month > endMonth) {
        continue;
      }

      if (status != 'concluído') {
        continue;
      }

      totalsByMonth[taskDate.month] =
          (totalsByMonth[taskDate.month] ?? 0) +
              (item.task.hours * item.task.clientHourlyRateSnapshot);
    }

    return <DashboardQuarterBar>[
      for (int month = startMonth; month <= endMonth; month++)
        DashboardQuarterBar(
          month: month,
          monthLabel: _monthShortLabel(month),
          value: totalsByMonth[month] ?? 0,
        ),
    ];
  }

  String _monthShortLabel(int month) {
    const Map<int, String> labels = <int, String>{
      1: 'Jan',
      2: 'Fev',
      3: 'Mar',
      4: 'Abr',
      5: 'Mai',
      6: 'Jun',
      7: 'Jul',
      8: 'Ago',
      9: 'Set',
      10: 'Out',
      11: 'Nov',
      12: 'Dez',
    };

    return labels[month] ?? '';
  }
}

class _QuarterRange {
  _QuarterRange({
    required this.year,
    required this.startMonth,
    required this.endMonth,
    required this.label,
  });

  final int year;
  final int startMonth;
  final int endMonth;
  final String label;
}