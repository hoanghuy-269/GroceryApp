import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import '../models/order.dart';
import 'package:grocery_app/database/database_provider.dart';

class RevenueStatisticsScreen extends StatefulWidget {
  const RevenueStatisticsScreen({super.key});

  @override
  State<RevenueStatisticsScreen> createState() =>
      _RevenueStatisticsScreenState();
}

class _RevenueStatisticsScreenState extends State<RevenueStatisticsScreen> {
  Map<DateTime, double> _dailyTotals = {};
  Map<DateTime, int> _dailyCounts = {};
  Map<DateTime, double> _filteredDailyTotals = {};
  Map<DateTime, int> _filteredDailyCounts = {};
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final database = await DatabaseProvider.database;
    final orderDao = database.orderDao;
    final orders = await orderDao.getAllOrders();

    final Map<DateTime, double> dailyTotals = {};
    final Map<DateTime, int> dailyCounts = {};

    for (var order in orders) {
      final date = DateTime(
        order.orderDate.year,
        order.orderDate.month,
        order.orderDate.day,
      );
      dailyTotals.update(
        date,
        (value) => value + order.totalAmount,
        ifAbsent: () => order.totalAmount,
      );
      dailyCounts.update(date, (value) => value + 1, ifAbsent: () => 1);
    }

    setState(() {
      _dailyTotals = dailyTotals;
      _dailyCounts = dailyCounts;
      // Initially, show all data
      _filteredDailyTotals = Map.from(dailyTotals);
      _filteredDailyCounts = Map.from(dailyCounts);
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange:
          _selectedDateRange ??
          DateTimeRange(
            start: DateTime.now().subtract(const Duration(days: 30)),
            end: DateTime.now(),
          ),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blueAccent,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _filterData();
      });
    }
  }

  void _filterData() {
    if (_selectedDateRange == null) {
      _filteredDailyTotals = Map.from(_dailyTotals);
      _filteredDailyCounts = Map.from(_dailyCounts);
      return;
    }

    final startDate = DateTime(
      _selectedDateRange!.start.year,
      _selectedDateRange!.start.month,
      _selectedDateRange!.start.day,
    );
    final endDate = DateTime(
      _selectedDateRange!.end.year,
      _selectedDateRange!.end.month,
      _selectedDateRange!.end.day,
    );

    final filteredTotals = <DateTime, double>{};
    final filteredCounts = <DateTime, int>{};

    _dailyTotals.forEach((date, total) {
      if (date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.add(const Duration(days: 1)))) {
        filteredTotals[date] = total;
        filteredCounts[date] = _dailyCounts[date] ?? 0;
      }
    });

    setState(() {
      _filteredDailyTotals = filteredTotals;
      _filteredDailyCounts = filteredCounts;
    });
  }

  void _clearFilter() {
    setState(() {
      _selectedDateRange = null;
      _filteredDailyTotals = Map.from(_dailyTotals);
      _filteredDailyCounts = Map.from(_dailyCounts);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedKeys = _filteredDailyTotals.keys.toList()..sort();

    final maxRevenue = _filteredDailyTotals.values.fold<double>(
      0,
      (prev, e) => e > prev ? e : prev,
    );
    final maxOrders = _filteredDailyCounts.values.fold<int>(
      0,
      (prev, e) => e > prev ? e : prev,
    );

    final totalRevenue = _filteredDailyTotals.values.fold<double>(
      0,
      (prev, e) => prev + e,
    );

    final totalOrders = _filteredDailyCounts.values.fold<int>(
      0,
      (prev, e) => prev + e,
    );

    final maxY =
        (maxRevenue > (maxOrders * 10000.0)
                ? maxRevenue + 10000.0
                : (maxOrders * 10000.0) + 10000.0)
            .toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống kê doanh thu'),
        backgroundColor: const Color.fromARGB(255, 43, 197, 146),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _selectDateRange(context),
            tooltip: 'Lọc theo ngày',
          ),
          if (_selectedDateRange != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilter,
              tooltip: 'Xóa bộ lọc',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            if (_selectedDateRange != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Từ ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.start)} '
                  'đến ${DateFormat('dd/MM/yyyy').format(_selectedDateRange!.end)}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Tổng doanh thu: ${NumberFormat.currency(locale: 'vi', symbol: 'VNĐ').format(totalRevenue)}\n'
                'Tổng số đơn hàng: $totalOrders',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 350,
              child:
                  sortedKeys.isEmpty
                      ? const Center(
                        child: Text(
                          'Không có dữ liệu trong khoảng thời gian này',
                        ),
                      )
                      : LayoutBuilder(
                        builder: (context, constraints) {
                          final barWidth = 24.0;
                          return Stack(
                            children: [
                              BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: maxY,
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      tooltipBgColor: Colors.white,
                                      getTooltipItem: (
                                        group,
                                        groupIndex,
                                        rod,
                                        rodIndex,
                                      ) {
                                        final date =
                                            sortedKeys[group.x.toInt()];
                                        final revenue =
                                            _filteredDailyTotals[date] ?? 0;
                                        final orders =
                                            _filteredDailyCounts[date] ?? 0;
                                        return BarTooltipItem(
                                          'Thu: ${NumberFormat.currency(locale: 'vi', symbol: '₫').format(revenue)}\n'
                                          'Số đơn: $orders',
                                          const TextStyle(color: Colors.black),
                                        );
                                      },
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40,
                                        getTitlesWidget: (value, meta) {
                                          final displayValue =
                                              value >= 1000
                                                  ? '${(value ~/ 1000)}K'
                                                  : value.toInt().toString();
                                          return Text(
                                            displayValue,
                                            style: const TextStyle(
                                              fontSize: 10,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    rightTitles: AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          if (index >= 0 &&
                                              index < sortedKeys.length) {
                                            return Text(
                                              DateFormat(
                                                'dd/MM',
                                              ).format(sortedKeys[index]),
                                              style: const TextStyle(
                                                fontSize: 10,
                                              ),
                                            );
                                          } else {
                                            return const Text('');
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: true),
                                  barGroups: List.generate(sortedKeys.length, (
                                    index,
                                  ) {
                                    final date = sortedKeys[index];
                                    final revenue =
                                        _filteredDailyTotals[date] ?? 0;
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: revenue,
                                          color: const Color.fromARGB(
                                            255,
                                            63,
                                            181,
                                            122,
                                          ),
                                          width: barWidth,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                      ],
                                      showingTooltipIndicators: [0],
                                    );
                                  }),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  Color.fromARGB(255, 63, 181, 122),
                  'Doanh thu',
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
