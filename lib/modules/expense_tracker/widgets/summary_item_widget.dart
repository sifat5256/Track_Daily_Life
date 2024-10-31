
import 'package:flutter/material.dart';

import '../../../helpers/responsive_text_size.dart';


class SummaryItem extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;

  const SummaryItem({
    required this.title,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Define text styles for consistency and reusability
    final TextStyle titleStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: ResponsiveText.textSize(15),
      color: color,
    );

    final TextStyle amountStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: ResponsiveText.textSize(13),
    );

    return Container(
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black12,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: titleStyle,
              semanticsLabel: title, // Accessibility
            ),
            Text(
              '\$${amount.toStringAsFixed(2)}',
              style: amountStyle,
              semanticsLabel: 'Amount: \$${amount.toStringAsFixed(2)}', // Accessibility
            ),
          ],
        ),
      ),
    );
  }
}
