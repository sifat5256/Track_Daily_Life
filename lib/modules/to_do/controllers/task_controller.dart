import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class TaskController extends GetxController {
  var allTasks = <Map<String, dynamic>>[].obs;
  var completeTasks = <Map<String, dynamic>>[].obs;
  var ongoingTasks = <Map<String, dynamic>>[].obs;
  var canceledTasks = <Map<String, dynamic>>[].obs;
  var selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tasksString = prefs.getString('tasks');
    if (tasksString != null) {
      List<dynamic> jsonTasks = jsonDecode(tasksString);
      List<Map<String, dynamic>> loadedTasks = jsonTasks.map((e) => Map<String, dynamic>.from(e)).toList();
      allTasks.assignAll(loadedTasks);
      _filterTasksByStatus();
    }
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String tasksString = jsonEncode(allTasks);
    await prefs.setString('tasks', tasksString);
  }

  void addTask(String title, String description, DateTime dueDate, TimeOfDay dueTime, String status, Color color) {
    final newTask = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'dueTime': '${dueTime.hour}:${dueTime.minute}',
      'status': status,
      'color': color.value,
    };
    allTasks.add(newTask);
    _filterTasksByStatus();
    _saveTasks();
  }

  void deleteTask(String id) {
    allTasks.removeWhere((task) => task['id'] == id);
    _filterTasksByStatus();
    _saveTasks();
  }

  void updateTaskStatus(String id, String newStatus) {
    int index = allTasks.indexWhere((task) => task['id'] == id);
    if (index != -1) {
      allTasks[index]['status'] = newStatus;
      _filterTasksByStatus();
      _saveTasks();
    }
  }

  void editTask(String id, String title, String description, DateTime dueDate, TimeOfDay dueTime, String status, Color color) {
    int index = allTasks.indexWhere((task) => task['id'] == id);
    if (index != -1) {
      allTasks[index] = {
        'id': id,
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'dueTime': '${dueTime.hour}:${dueTime.minute}',
        'status': status,
        'color': color.value,
      };
      _filterTasksByStatus();
      _saveTasks();
    }
  }

  void _filterTasksByStatus() {
    completeTasks.value = allTasks.where((task) => task['status'] == 'Complete').toList();
    ongoingTasks.value = allTasks.where((task) => task['status'] == 'Ongoing').toList();
    canceledTasks.value = allTasks.where((task) => task['status'] == 'Canceled').toList();
  }

  void clearAllTasks() {
    allTasks.clear();
    completeTasks.clear();
    ongoingTasks.clear();
    canceledTasks.clear();
    _saveTasks();
  }

  void confirmClearAllTasks() {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure you want to clear all tasks?'),
        actions: [
          TextButton(
            onPressed: () {
              clearAllTasks();
              Get.back();
            },
            child: const Text('Yes'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('No'),
          ),
        ],
      ),
    );
  }

  void changeDate(DateTime date) {
    selectedDate.value = date;
  }
}
