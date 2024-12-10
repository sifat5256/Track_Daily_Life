
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

import '../widgets/expense_summary.dart';


class BorrowLendScreen extends StatefulWidget {
  @override
  _BorrowLendScreenState createState() => _BorrowLendScreenState();
}

class _BorrowLendScreenState extends State<BorrowLendScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _borrowAmountController = TextEditingController();
  final TextEditingController _borrowPersonController = TextEditingController();
  final TextEditingController _lendAmountController = TextEditingController();
  final TextEditingController _lendPersonController = TextEditingController();

  List<Map<String, dynamic>> borrowedList = [];
  List<Map<String, dynamic>> lentList = [];
  DateTime _selectedDate = DateTime.now();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData(); // Load data from SharedPreferences on initialization
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addBorrowEntry() {
    if (_borrowAmountController.text.isEmpty || _borrowPersonController.text.isEmpty) {
      _showErrorDialog("Please fill in both amount and person's name.");
      return;
    }
    setState(() {
      borrowedList.add({
        'amount': double.tryParse(_borrowAmountController.text) ?? 0.0,
        'person': _borrowPersonController.text,
        'date': _selectedDate.toString(),
      });
      _borrowAmountController.clear();
      _borrowPersonController.clear();
      _saveData(); // Save updated data
    });
    Get.back();
  }

  void _addLendEntry() {
    if (_lendAmountController.text.isEmpty || _lendPersonController.text.isEmpty) {
      _showErrorDialog("Please fill in both amount and person's name.");
      return;
    }
    setState(() {
      lentList.add({
        'amount': double.tryParse(_lendAmountController.text) ?? 0.0,
        'person': _lendPersonController.text,
        'date': _selectedDate.toString(),
      });
      _lendAmountController.clear();
      _lendPersonController.clear();
      _saveData(); // Save updated data
    });
    Get.back();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  double _calculateTotalBorrowed() {
    return borrowedList.fold(0.0, (sum, item) => sum + item['amount']);
  }

  double _calculateTotalLent() {
    return lentList.fold(0.0, (sum, item) => sum + item['amount']);
  }

  // Function to delete borrowed entry
  void _deleteBorrowedEntry(int index) {
    setState(() {
      borrowedList.removeAt(index);
      _saveData(); // Save updated data
    });
  }

  // Function to delete lent entry
  void _deleteLentEntry(int index) {
    setState(() {
      lentList.removeAt(index);
      _saveData(); // Save updated data
    });
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Entry here"),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                TabBar(
                  controller: _tabController,
                  tabs: [
                    const Tab(text: "Borrow Money"),
                    const Tab(text: "Lend Money"),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBorrowTab(),
                      _buildLendTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBorrowTab() {
    return Column(
      children: [
        TextField(
          controller: _borrowAmountController,
          decoration: const InputDecoration(labelText: "Amount"),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _borrowPersonController,
          decoration: const InputDecoration(labelText: "Person's Name"),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text("Selected Date: ${DateFormat.yMd().format(_selectedDate)}"),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _addBorrowEntry,
          child: const Text("Add Borrow Entry"),
        ),
      ],
    );
  }

  Widget _buildLendTab() {
    return Column(
      children: [
        TextField(
          controller: _lendAmountController,
          decoration: const InputDecoration(labelText: "Amount"),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _lendPersonController,
          decoration: const InputDecoration(labelText: "Person's Name"),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text("Selected Date: ${DateFormat.yMd().format(_selectedDate)}"),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date'),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: _addLendEntry,
          child: const Text("Add Lend Entry"),
        ),
      ],
    );
  }

  // Save data to SharedPreferences
  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('borrowedList', jsonEncode(borrowedList));
    prefs.setString('lentList', jsonEncode(lentList));
  }

  // Load data from SharedPreferences
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? borrowedData = prefs.getString('borrowedList');
    String? lentData = prefs.getString('lentList');

    if (borrowedData != null) {
      setState(() {
        borrowedList = List<Map<String, dynamic>>.from(jsonDecode(borrowedData));
      });
    }

    if (lentData != null) {
      setState(() {
        lentList = List<Map<String, dynamic>>.from(jsonDecode(lentData));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Borrow and Lend Money"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SummaryCard(
                  title: "\$${_calculateTotalBorrowed()}",
                  subtitle: 'Total Borrowed:',
                  backgroundColor: Colors.greenAccent.shade100,
                  icon: Icons.money_off,
                  textColor: Colors.red.shade900,
                ),

                SummaryCard(
                  title: "\$${_calculateTotalLent()}",
                  subtitle: 'Total Lent:',
                  backgroundColor: Colors.redAccent.shade100,
                  icon: Icons.attach_money_outlined,
                  textColor: Colors.red.shade900,
                ),
              ],
            ),

            const SizedBox(height: 20),
            Expanded(
              child: Row(
                children: [
                  // Borrowed List on the left side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Borrowed List",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: borrowedList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.greenAccent.shade100,

                                      ),

                                      child: ListTile(
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${borrowedList[index]['person']}",
                                            ),
                                            Text(
                                              "\$${borrowedList[index]['amount']}",
                                            ),
                                          ],
                                        ),
                                        subtitle: Text(
                                          DateFormat.yMd().format(DateTime.parse(borrowedList[index]['date'])),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteBorrowedEntry(index);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),


                  // Vertical Divider
                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                    color: Colors.grey,
                  ),

                  // Lent List on the right side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Lent List",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: lentList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.redAccent.shade100,
                                        ),

                                        child: ListTile(
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${lentList[index]['person']}",
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                              Text(
                                                "\$${lentList[index]['amount']}",
                                                style: const TextStyle(fontSize: 16),
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(
                                            DateFormat.yMd().format(DateTime.parse(lentList[index]['date'])),
                                          ),

                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _deleteLentEntry(index);
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )


                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _openBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}