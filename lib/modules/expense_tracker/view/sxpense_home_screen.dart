
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/expense_controller.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/expense_summary.dart';
import '../widgets/summary_item_widget.dart';
import '../widgets/transaction_list_widget.dart';
import 'add_transaction_screen.dart';
import 'borrow_lends_screen.dart';
import 'chart_screen.dart';

class ExpenseHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ExpenseController controller = Get.put(ExpenseController());

    return Scaffold(

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text('Expense Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _confirmClearHistory(controller),
          ),
        ],
      ),
      body: Obx(() {
        return Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpenseSummary(),


            Obx(() {
              return DatePicker(
                DateTime.now(),
                height: MediaQuery.of(context).size.height*0.11,
                initialSelectedDate: controller.selectedDate.value,
                selectionColor: Colors.green,
                selectedTextColor: Colors.black,
                onDateChange: (date) {
                  controller.changeDate(date);
                },
              );
            }),

            // Date Selector
            // HorizontalDateSelector(
            //   dateCount: 30,
            //   onDateSelected: (selectedDate) {
            //     controller.setSelectedDate(selectedDate);
            //   },
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => controller.changeDate(
                      controller.selectedDate.value.subtract(const Duration(days: 1))),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back),
                      Text("Previous"),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => controller.changeDate(
                      controller.selectedDate.value.add(const Duration(days: 1))),
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_forward),
                      Text("Next"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.greenAccent,
                  ),
                ),
                const Text("Daily Transaction",style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),),
                Expanded(
                  child: Container(
                    height: 1,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Summary Items (Income, Expense, Balance)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SummaryItem(
                  title: 'Income',
                  amount: controller.totalIncome.value,
                  color: Colors.green,
                ),
                SummaryItem(
                  title: 'Expense',
                  amount: controller.totalExpense.value,
                  color: Colors.red,
                ),
                SummaryItem(
                  title: 'Balance',
                  amount: controller.totalIncome.value - controller.totalExpense.value,
                  color: Colors.blue,
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Transaction List
            // Expanded(
            //   child: TransactionList(transactions: controller.filteredTransactions, onDelete: (TransactionModel ) {  },),
            // ),
            Expanded(
              child: TransactionList(
                transactions: controller.filteredTransactions,
                onDelete: (transactionId) {
                  controller.deleteTransaction(transactionId);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () => _openAddTransactionScreen(),
      ),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) => _onBottomNavBarItemTapped(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Chart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.currency_exchange_outlined),
              label: 'Borrow & Lends',
            ),
          ],
        );
      }),
    );
  }

  void _confirmClearHistory(ExpenseController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Clear All History'),
        content: const Text(
            'Are you sure you want to clear all transaction history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.clearAllHistory();
              Get.back();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _openAddTransactionScreen() {
    Get.to(() => AddTransactionScreen(
      onAddTransaction: (transaction) {
        Get.find<ExpenseController>().addTransaction(transaction);
      },
    ));
  }

  void _openChartScreen() {
    Get.to(() => ChartScreen(transactions: Get.find<ExpenseController>().filteredTransactions));
  }

  void _borrowScreen() {
    Get.to(() => BorrowLendScreen());
  }

  void _onBottomNavBarItemTapped(int index) {
    final ExpenseController controller = Get.find();
    controller.selectedIndex.value = index;

    if (index == 1) {
      _openChartScreen();
    } else if (index == 2) {
      _borrowScreen();
    }
  }
}
