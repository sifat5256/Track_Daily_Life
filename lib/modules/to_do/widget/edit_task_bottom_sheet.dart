

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../controllers/task_controller.dart';

class EditTaskBottomSheet extends StatefulWidget {
  final Map<String, dynamic> task;

  EditTaskBottomSheet({required this.task});

  @override
  _EditTaskBottomSheetState createState() => _EditTaskBottomSheetState();
}

class _EditTaskBottomSheetState extends State<EditTaskBottomSheet> {
  final TaskController taskController = Get.find();
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late DateTime dueDate;
  late TimeOfDay dueTime;
  late String status;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    descriptionController = TextEditingController(text: widget.task['description']);
    dueDate = DateTime.parse(widget.task['dueDate']);
    List<String> timeParts = widget.task['dueTime'].split(':');
    dueTime = TimeOfDay(hour: int.parse(timeParts[0]), minute: int.parse(timeParts[1]));
    status = widget.task['status'];
    selectedColor = Color(widget.task['color']);
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Date: ${DateFormat.yMd().format(dueDate)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: const Text("Pick Date"),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: dueDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null && pickedDate != dueDate) {
                          setState(() {
                            dueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Selected Time: ${dueTime.format(context)}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: const Text("Pick Time"),
                      onPressed: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: dueTime,
                        );
                        if (pickedTime != null && pickedTime != dueTime) {
                          setState(() {
                            dueTime = pickedTime;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                DropdownButton<String>(
                  value: status,
                  items: <String>['Ongoing', 'Complete', 'Canceled'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      status = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 15),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: <Color>[
                    Colors.blue,
                    Colors.green,
                    Colors.red,
                    Colors.yellow,
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
                        color: color,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Title cannot be empty')),
                        );
                        return;
                      }
                      taskController.editTask(
                        widget.task['id'],
                        titleController.text,
                        descriptionController.text,
                        dueDate,
                        dueTime,
                        status,
                        selectedColor,
                      );
                      Get.back(); // Close the bottom sheet after editing
                    },
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
