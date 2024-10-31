

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../app/data/models/transaction_model.dart';
import '../view/borrow_lends_screen.dart';
import '../view/chart_screen.dart';





class ExpenseController extends GetxController {
  var transactions = <TransactionModel>[].obs;
  var filteredTransactions = <TransactionModel>[].obs;
  var totalIncome = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalAllIncome = 0.0.obs;
  var totalAllExpense = 0.0.obs;
  var selectedDate = DateTime.now().obs;
  var selectedIndex = 0.obs;

  // Add a getter for balance
  double get balance => totalIncome.value - totalExpense.value;

  @override
  void onInit() {
    super.onInit();
    _loadTransactions();
  }
  void setSelectedDate(DateTime date) {
    selectedDate.value = date;
    _filterTransactionsByDate(date);
  }

  Future<void> _loadTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? transactionsData = prefs.getString('transactions');
    if (transactionsData != null) {
      List<dynamic> decodedData = json.decode(transactionsData);
      transactions.value = decodedData
          .map((item) => TransactionModel.fromJson(item))
          .toList();
      _filterTransactionsByDate(selectedDate.value);
      _calculateTotals();
    }
  }

  Future<void> _saveTransactions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = json.encode(
      transactions.map((tx) => tx.toJson()).toList(),
    );
    await prefs.setString('transactions', encodedData);


  }


  void _calculateTotals() {
    // Calculate totals for filtered transactions (daily totals)
    totalIncome.value = filteredTransactions
        .where((tx) => tx.type == 'Income')
        .fold(0.0, (sum, tx) => sum + tx.amount);
    totalExpense.value = filteredTransactions
        .where((tx) => tx.type == 'Expense')
        .fold(0.0, (sum, tx) => sum + tx.amount);

    // Calculate totals for all transactions (overall totals)
    totalAllIncome.value = transactions
        .where((tx) => tx.type == 'Income')
        .fold(0.0, (sum, tx) => sum + tx.amount);
    totalAllExpense.value = transactions
        .where((tx) => tx.type == 'Expense')
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  void addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
    _filterTransactionsByDate(selectedDate.value);
    _calculateTotals();
    _saveTransactions();
  }

  void deleteTransaction(String transactionId) {
    transactions.removeWhere((tx) => tx.id == transactionId);
    _filterTransactionsByDate(selectedDate.value);
    _calculateTotals();
    _saveTransactions();
  }

  void clearAllHistory() async {
    transactions.clear();
    totalIncome.value = 0.0;
    totalExpense.value = 0.0;
    totalAllIncome.value = 0.0;
    totalAllExpense.value = 0.0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('transactions');
  }

  void _filterTransactionsByDate(DateTime date) {
    filteredTransactions.value = transactions
        .where((tx) =>
    tx.dateTime.year == date.year &&
        tx.dateTime.month == date.month &&
        tx.dateTime.day == date.day)
        .toList();
    _calculateTotals();
  }

  // This method will be used to update the selected date and filter transactions accordingly
  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    _filterTransactionsByDate(newDate);  // Ensure transactions are filtered based on the new date
  }

  // Handling bottom navigation
  void onBottomNavBarItemTapped(int index) {
    selectedIndex.value = index;
    if (index == 1) {
      _openChartScreen();
    } else if (index == 2) {
      _openBorrowScreen();
    }
  }

  // Navigation to chart screen
  void _openChartScreen() {
    Get.to(() => ChartScreen(transactions: filteredTransactions));
  }

  // Navigation to borrow and lends screen
  void _openBorrowScreen() {
    Get.to(() => BorrowLendScreen());
  }
}

