import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helpers/responsive_sizing.dart';
import '../../../helpers/responsive_text_size.dart';
import '../controllers/expense_controller.dart';


class ExpenseSummary extends StatefulWidget {
  @override
  _ExpenseSummaryState createState() => _ExpenseSummaryState();
}

class _ExpenseSummaryState extends State<ExpenseSummary> {
  late ScrollController _scrollController;
  Timer? _timer;
  final double _scrollAmount = 200; // Amount to scroll each time

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_scrollController.hasClients) {
        if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
          // Reset to the beginning
          _scrollController.jumpTo(0);
        } else {
          _scrollController.animateTo(
            _scrollController.offset + _scrollAmount,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseController expenseController = Get.find();

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Total Income Card
              const SizedBox(width: 8),
              SummaryCard(
                title: '\$${expenseController.totalAllIncome.value.toStringAsFixed(1)}',
                subtitle: 'Total Income',
                backgroundColor: Colors.greenAccent.shade100,
                icon: Icons.attach_money,
                textColor: Colors.green.shade900,
              ),
              const SizedBox(width: 8),

              // Total Expense Card
              SummaryCard(
                title: '\$${expenseController.totalAllExpense.value.toStringAsFixed(1)}',
                subtitle: 'Total Expense',
                backgroundColor: Colors.redAccent.shade100,
                icon: Icons.money_off,
                textColor: Colors.red.shade900,
              ),
              const SizedBox(width: 8),

              // Balance Card
              SummaryCard(
                title: '\$${(expenseController.totalAllIncome.value - expenseController.totalAllExpense.value).toStringAsFixed(1)}',
                subtitle: 'Balance',
                backgroundColor: (expenseController.totalAllIncome.value - expenseController.totalAllExpense.value) >= 0
                    ? Colors.lightGreenAccent.shade100
                    : Colors.redAccent.shade100,
                icon: Icons.account_balance_wallet,
                textColor: (expenseController.totalAllIncome.value - expenseController.totalAllExpense.value) >= 0
                    ? Colors.green.shade900
                    : Colors.red.shade900,
              ),
              // const SizedBox(width: 8),

              // Additional Cards if necessary

            ],
          ),
        ),
      );
    });
  }
}

// Custom widget for summary cards
class SummaryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final IconData icon;
  final Color textColor;

  SummaryCard({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ResponsiveSize.width(160),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(icon, size: 28, color: textColor),
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveText.textSize(18),
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: ResponsiveText.textSize(18),
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
