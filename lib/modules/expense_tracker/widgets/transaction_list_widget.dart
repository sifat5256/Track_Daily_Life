
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../app/data/models/transaction_model.dart';


class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(String) onDelete;

  const TransactionList({
    required this.transactions,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('No transactions available.'),
          Image.asset("lib/utils/assets/transaction.png",height: 120,)
        ],
      );
    }

    return ListView.builder(
      // physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        Color backgroundColor = (transaction.type == 'Income' ? Colors.greenAccent.shade100 : Colors.redAccent.shade100);

        return Card(
          color: backgroundColor,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              transaction.description,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(DateFormat.yMMMd().format(transaction.dateTime), style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(DateFormat.jm().format(transaction.dateTime), style: TextStyle(fontSize: 14)),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '\$${transaction.amount.toStringAsFixed(2)}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Show confirmation dialog before deletion
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Deletion'),
                        content: Text('Are you sure you want to delete "${transaction.description}"?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () {
                              onDelete(transaction.id); // Call the delete function
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
