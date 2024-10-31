
import 'package:flutter/material.dart';

import '../../../helpers/responsive_sizing.dart';


class HorizontalDateSelector extends StatefulWidget {
  final int dateCount; // The number of dates to display
  final int pastDaysCount; // Number of past days to include
  final ValueChanged<DateTime> onDateSelected; // Callback for selected date

  HorizontalDateSelector({
    required this.dateCount,
    required this.onDateSelected,
    this.pastDaysCount = 0, // Default to 0 for no past days
  });

  @override
  _HorizontalDateSelectorState createState() => _HorizontalDateSelectorState();
}

class _HorizontalDateSelectorState extends State<HorizontalDateSelector> {
  int selectedIndex = 0; // Track the selected index

  // Function to generate a list of DateTime objects including past and future dates
  List<DateTime> generateDates(int pastDaysCount, int futureDaysCount) {
    List<DateTime> dates = [];

    // Generate past dates
    for (int i = pastDaysCount; i > 0; i--) {
      dates.add(DateTime.now().subtract(Duration(days: i)));
    }

    // Generate today and future dates
    dates.addAll(List<DateTime>.generate(
      futureDaysCount + 1, // +1 for today
          (index) => DateTime.now().add(Duration(days: index)),
    ));

    return dates;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> dates = generateDates(widget.pastDaysCount, widget.dateCount);

    return Container(
      height: ResponsiveSize.height(90),

      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          DateTime date = dates[index];
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onDateSelected(date); // Callback to pass the selected date
            },
            child: Container(
              width: ResponsiveSize.width(70), // Example width
              height: ResponsiveSize.height(110), // Example height// Adjust the width based on your design
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${date.month.toString().padLeft(2, '0')}", // Display month
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.black,
                    ),
                    semanticsLabel: 'Month ${date.month}',
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${date.day}", // Display day
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : Colors.black,
                    ),
                    semanticsLabel: 'Day ${date.day}',
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "${["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][date.weekday % 7]}", // Day of week
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.black,
                    ),
                    semanticsLabel: 'Day of week ${["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"][date.weekday % 7]}',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
