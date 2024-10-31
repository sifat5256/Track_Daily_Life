import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

import '../controllers/task_controller.dart';

class AddTaskBottomSheet extends StatefulWidget {
  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet>
    with SingleTickerProviderStateMixin {
  final TaskController taskController = Get.find();
  String title = '';
  String description = '';
  DateTime selectedDueDate = DateTime.now();
  TimeOfDay selectedDueTime = TimeOfDay.now();
  String taskStatus = 'Ongoing';
  Color selectedColor = Colors.blue;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      )),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 10),
                // Title input field
                _buildInputField(
                  label: 'Title',
                  onChanged: (value) => title = value,
                ),
                // Description input field
                _buildInputField(
                  label: 'Description',
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 20),
                // Date picker row
                _buildDatePicker(),
                const SizedBox(height: 15),
                // Time picker row
                _buildTimePicker(),
                const SizedBox(height: 20),
                // Task status dropdown
                _buildStatusDropdown(),
                const SizedBox(height: 20),
                // Color selection chips
                _buildColorChips(),
                const SizedBox(height: 20),
                // Add task button
                Center(
                  child: ElevatedButton(
                    onPressed: _addTask,
                    child: const Text('Add Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required Function(String) onChanged}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Date: ${DateFormat.yMd().format(selectedDueDate)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.calendar_today),
          label: const Text("Pick Date"),
          onPressed: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDueDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null && pickedDate != selectedDueDate) {
              setState(() {
                selectedDueDate = pickedDate;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Time: ${selectedDueTime.format(context)}",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.access_time),
          label: const Text("Pick Time"),
          onPressed: () async {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: selectedDueTime,
            );
            if (pickedTime != null && pickedTime != selectedDueTime) {
              setState(() {
                selectedDueTime = pickedTime;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButton<String>(
      value: taskStatus,
      items: <String>['Ongoing', 'Complete', 'Canceled']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          taskStatus = newValue!;
        });
      },
    );
  }

  Widget _buildColorChips() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: <Color>[
        Colors.blue,
        Colors.green,
        Colors.red,
        Colors.orange,
        Colors.purple
      ].map((Color color) {
        return ChoiceChip(
          selected: selectedColor == color,
          onSelected: (bool selected) {
            setState(() {
              selectedColor = color;
            });
          },
          label: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      }).toList(),
    );
  }

  void _addTask() {
    if (title.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title cannot be empty')),
      );
      return;
    }
    taskController.addTask(
      title,
      description,
      selectedDueDate,
      selectedDueTime,
      taskStatus,
      selectedColor,
    );
    Get.back();
  }
}
