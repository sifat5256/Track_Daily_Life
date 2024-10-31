

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../app/data/models/transaction_model.dart';

// Importing uuid for unique ID generation

class AddTransactionController extends GetxController {
  var type = 'Income'.obs;
  var amount = ''.obs; // Store as String to handle TextField input directly
  var description = ''.obs;
  var selectedDate = DateTime.now().obs;
  var selectedTime = TimeOfDay.now().obs;

  void setType(String newType) {
    type.value = newType;
  }

  void setAmount(String value) {
    amount.value = value; // Keep it as String for TextField input
  }

  void setDescription(String value) {
    description.value = value;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void setTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void addTransaction(Function(TransactionModel) onAddTransaction) {
    if (amount.value.isEmpty || double.tryParse(amount.value) == null) {
      // Show error if amount is invalid
      Get.snackbar('Error', 'Please enter a valid amount');
      return;
    }

    DateTime finalDateTime = DateTime(
      selectedDate.value.year,
      selectedDate.value.month,
      selectedDate.value.day,
      selectedTime.value.hour,
      selectedTime.value.minute,
    );

    // Generate a unique ID for the new transaction
    final String transactionId = Uuid().v4();

    TransactionModel newTransaction = TransactionModel(
      id: transactionId, // Include the unique ID
      type: type.value,
      amount: double.parse(amount.value), // Convert to double
      description: description.value,
      dateTime: finalDateTime,
    );

    onAddTransaction(newTransaction);
  }
}
