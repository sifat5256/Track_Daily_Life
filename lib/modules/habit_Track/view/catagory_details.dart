import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/habit_controller.dart';

class CategoryDetailPage extends StatelessWidget {
  final int index;

  CategoryDetailPage({required this.index});

  final HabitController habitController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(habitController.categories[index].name)),
        backgroundColor: Colors.green,
      ),
      body: Obx(
            () => ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: habitController.categories[index].items.length,
          itemBuilder: (context, itemIndex) {
            final item = habitController.categories[index].items[itemIndex];

            return ListTile(
              leading: Checkbox(
                value: item.completed,
                onChanged: (value) {
                  habitController.toggleHabitCompletion(index, itemIndex);
                },
              ),
              title: Text(
                item.title,
                style: TextStyle(
                  decoration: item.completed ? TextDecoration.lineThrough : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
