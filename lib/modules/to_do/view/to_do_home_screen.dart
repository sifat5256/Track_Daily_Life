

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


import '../../../helpers/responsive_sizing.dart';
import '../../../helpers/responsive_text_size.dart';
import '../controllers/task_controller.dart';
import '../widget/add_task_bottom_sheet.dart';
import '../widget/edit_task_bottom_sheet.dart';


class ToDoHomePage extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () => taskController.confirmClearAllTasks(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTaskCountRow(),
          const SizedBox(height: 20),
          Obx(() {
            return DatePicker(
              DateTime.now(),
              height: MediaQuery.of(context).size.height*0.11,
              initialSelectedDate: taskController.selectedDate.value,
              selectionColor: Colors.green,
              selectedTextColor: Colors.black,
              onDateChange: (date) {
                taskController.changeDate(date);
              },
            );
          }),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => taskController.changeDate(taskController.selectedDate.value.subtract(const Duration(days: 1))),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back),
                    Text("Previous"),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => taskController.changeDate(taskController.selectedDate.value.add(const Duration(days: 1))),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_forward),
                    Text("Next"),
                  ],
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: _buildTaskList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _openAddTaskBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskCountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(() => _buildTaskCountCard('Total', taskController.allTasks.length)),
        Obx(() => _buildTaskCountCard('Ongoing', taskController.ongoingTasks.length)),
        Obx(() => _buildTaskCountCard('Complete', taskController.completeTasks.length)),
        Obx(() => _buildTaskCountCard('Canceled', taskController.canceledTasks.length)),
      ],
    );
  }

  Widget _buildTaskCountCard(String title, int count) {
    return Card(
      color: Colors.greenAccent.shade400,
      elevation: 5,
      child: SizedBox(
        width: ResponsiveSize.width(80), // Example width
        height: ResponsiveSize.height(80), // Example height
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style:  TextStyle(fontWeight: FontWeight.bold,
                  fontSize: ResponsiveText.textSize(16),
                ),
              ),
              Text(
                '$count',
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return Obx(() {
      List<Map<String, dynamic>> filteredTasks = taskController.allTasks.where((task) {
        DateTime dateTime = DateTime.parse(task['dueDate']);
        return dateTime.year == taskController.selectedDate.value.year &&
            dateTime.month == taskController.selectedDate.value.month &&
            dateTime.day == taskController.selectedDate.value.day;
      }).toList();

      return filteredTasks.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("lib/utils/assets/list.png", fit: BoxFit.cover, height: 150),
            const Text("No Task Today", style: TextStyle(fontSize: 20)),
          ],
        ),
      )
          : ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          var task = filteredTasks[index];
          DateTime dueDate = DateTime.parse(task['dueDate']);
          List<String> timeParts = task['dueTime'].split(':');
          TimeOfDay dueTime = TimeOfDay(
            hour: int.parse(timeParts[0]),
            minute: int.parse(timeParts[1]),
          );
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(task['color']),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  task['description'],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Due Date: ${DateFormat.yMd().format(dueDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      dueTime.format(context),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Status: ${task['status']}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        _openEditTaskBottomSheet(task);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () {
                        taskController.deleteTask(task['id']);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _openEditTaskBottomSheet(Map<String, dynamic> task) {
    Get.bottomSheet(
      EditTaskBottomSheet(task: task),
    );
  }

  void _openAddTaskBottomSheet() {
    Get.bottomSheet(
      AddTaskBottomSheet(),
    );
  }
}
