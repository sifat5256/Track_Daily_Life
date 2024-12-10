
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../app/data/models/transaction_model.dart';


class ChartScreen extends StatelessWidget {
  final List<TransactionModel> transactions;

  ChartScreen({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Expense Chart'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxYValue(),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        value.toString(),
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    final dateKey = _dateKeys[index];
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        dateKey,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: true),
            barGroups: _getBarGroups(),
          ),
        ),
      ),
    );
  }

  double _getMaxYValue() {
    if (transactions.isEmpty) return 10.0; // Default value if no transactions

    double maxExpense = transactions
        .where((tx) => tx.type == 'Expense')
        .map((tx) => tx.amount)
        .fold(0.0, (prev, amount) => amount > prev ? amount : prev);
    double maxIncome = transactions
        .where((tx) => tx.type == 'Income')
        .map((tx) => tx.amount)
        .fold(0.0, (prev, amount) => amount > prev ? amount : prev);

    return (maxExpense > maxIncome ? maxExpense : maxIncome) + 10;
  }

  List<BarChartGroupData> _getBarGroups() {
    final Map<String, double> expenseMap = {};
    final Map<String, double> incomeMap = {};
    final List<String> dateKeys = [];

    for (var transaction in transactions) {
      final dateKey = '${transaction.dateTime.month}/${transaction.dateTime.year}';
      if (!dateKeys.contains(dateKey)) {
        dateKeys.add(dateKey);
      }
      if (transaction.type == 'Expense') {
        expenseMap[dateKey] = (expenseMap[dateKey] ?? 0) + transaction.amount;
      } else {
        incomeMap[dateKey] = (incomeMap[dateKey] ?? 0) + transaction.amount;
      }
    }

    List<BarChartGroupData> barGroups = [];
    int index = 0;

    for (var dateKey in dateKeys) {
      double expenseValue = expenseMap[dateKey] ?? 0;
      double incomeValue = incomeMap[dateKey] ?? 0;

      barGroups.add(
        BarChartGroupData(
          x: index++,
          barRods: [
            BarChartRodData(
              toY: expenseValue,
              color: Colors.red,
              width: 20,
            ),
            BarChartRodData(
              toY: incomeValue,
              color: Colors.green,
              width: 20,
            ),
          ],
        ),
      );
    }

    _dateKeys = dateKeys;
    return barGroups;
  }

  // A list to store the date labels for the X-axis
  late final List<String> _dateKeys;
}
