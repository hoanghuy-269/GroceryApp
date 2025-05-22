// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:grocery_app/database/database_provider.dart';
// import 'package:intl/intl.dart';
// import 'package:grocery_app/database/app_database.dart';
// import 'package:grocery_app/models/order.dart';

// class OrderStatsScreen extends StatefulWidget {
//   const OrderStatsScreen({super.key});

//   @override
//   State<OrderStatsScreen> createState() => _OrderStatsScreenState();
// }

// class _OrderStatsScreenState extends State<OrderStatsScreen> {
//   late AppDatabase _database;
//   DateTime _startDate = DateTime(2025, 5, 14, 23, 59); // 11:59 PM, 14/05/2025
//   DateTime _endDate = DateTime(2025, 5, 21, 23, 59);   // 11:59 PM, 21/05/2025
//   Map<String, double> _dailyTotals = {};

//   @override
//   void initState() {
//     super.initState();
//     _loadDatabase();
//   }

//   Future<void> _loadDatabase() async {
//     _database = await DatabaseProvider.database;
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     final orders = await _database.orderDao.getAllOrders();
//     final filteredOrders =
//         orders
//             .where(
//               (o) =>
//                   o.orderDate.isAfter(
//                     _startDate.subtract(const Duration(days: 1)),
//                   ) &&
//                   o.orderDate.isBefore(_endDate.add(const Duration(days: 1))),
//             )
//             .toList();

//     final Map<String, double> dailyTotals = {};
//     final dateFormat = DateFormat('dd/MM');

//     for (var order in filteredOrders) {
//       final dateKey = dateFormat.format(order.orderDate);
//       final total = order. * order.quantity;

//       if (dailyTotals.containsKey(dateKey)) {
//         dailyTotals[dateKey] = dailyTotals[dateKey]! + total;
//       } else {
//         dailyTotals[dateKey] = total;
//       }
//     }

//     setState(() {
//       _dailyTotals = dailyTotals;
//     });
//   }

//   Future<void> _pickDateRange() async {
//     final picked = await showDateRangePicker(
//       context: context,
//       firstDate: DateTime(2023),
//       lastDate: DateTime.now(),
//       initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
//     );

//     if (picked != null) {
//       setState(() {
//         _startDate = picked.start;
//         _endDate = picked.end;
//       });
//       _fetchData();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sortedKeys = _dailyTotals.keys.toList()..sort();
//     final dateFormat = DateFormat('hh:mm a, dd/MM/yyyy');

//     return Scaffold(
//       appBar: AppBar(title: const Text('Thống kê đơn hàng')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: _pickDateRange,
//               child: const Text("Chọn khoảng ngày"),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Từ: ${dateFormat.format(_startDate)}', // 11:59 PM, 14/05/2025
//                   style: const TextStyle(fontSize: 16),
//                 ),
//                 Text(
//                   'Đến: ${dateFormat.format(_endDate)}', // 11:59 PM, 21/05/2025
//                   style: const TextStyle(fontSize: 16),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY:
//                       _dailyTotals.values.isNotEmpty
//                           ? _dailyTotals.values.reduce(
//                                 (a, b) => a > b ? a : b,
//                               ) +
//                               10000
//                           : 100,
//                   barTouchData: BarTouchData(enabled: true),
//                   titlesData: FlTitlesData(
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         reservedSize: 40,
//                       ),
//                     ),
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           final index = value.toInt();
//                           if (index >= 0 && index < sortedKeys.length) {
//                             return Text(
//                               sortedKeys[index],
//                               style: const TextStyle(fontSize: 10),
//                             );
//                           }
//                           return const Text('');
//                         },
//                       ),
//                     ),
//                   ),
//                   barGroups: List.generate(sortedKeys.length, (index) {
//                     final key = sortedKeys[index];
//                     final amount = _dailyTotals[key]!;
//                     return BarChartGroupData(
//                       x: index,
//                       barRods: [
//                         BarChartRodData(
//                           toY: amount,
//                           width: 16,
//                           color: Colors.green,
//                         ),
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
