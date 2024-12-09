import 'package:get/get.dart';

import '../model/habit_catagory.dart';

class HabitController extends GetxController {
  var categories = <HabitCategory>[
    // Health and Fitness
    HabitCategory(
      name: 'Health and Fitness',
      icon: 'lib/utils/assets/workout.png',
      items: [
        HabitItem(title: 'Daily Workout'),
        HabitItem(title: 'Drink Water'),
        HabitItem(title: 'Sleep 8 Hours'),
        HabitItem(title: 'Eat Vegetables'),
        HabitItem(title: 'Hit Step Count'),
      ],
    ),

    // Productivity
    HabitCategory(
      name: 'Productivity',
      icon: 'lib/utils/assets/improvement.png',
      items: [
        HabitItem(title: 'Complete To-Do List'),
        HabitItem(title: 'Read a Chapter'),
        HabitItem(title: 'Plan Daily Tasks'),
        HabitItem(title: 'Focus Time'),
        HabitItem(title: 'Learn New Skills'),
      ],
    ),

    // Mental Wellness
    HabitCategory(
      name: 'Mental Wellness',
      icon: 'lib/utils/assets/mental-health.png',
      items: [
        HabitItem(title: 'Meditation'),
        HabitItem(title: 'Gratitude Practice'),
        HabitItem(title: 'Journaling'),
        HabitItem(title: 'Digital Detox'),
      ],
    ),

    // Relationships and Social
    HabitCategory(
      name: 'Relationships & Social',
      icon: 'lib/utils/assets/agreement.png',
      items: [
        HabitItem(title: 'Call Family'),
        HabitItem(title: 'Acts of Kindness'),
        HabitItem(title: 'Reach Out to Friends'),
        HabitItem(title: 'Build Connections'),
      ],
    ),

    // Financial
    HabitCategory(
      name: 'Financial',
      icon: 'lib/utils/assets/financial-statement.png',
      items: [
        HabitItem(title: 'Save Money'),
        HabitItem(title: 'Log Expenses'),
        HabitItem(title: 'Stick to Budget'),
      ],
    ),

    // Personal Growth
    HabitCategory(
      name: 'Personal Growth',
      icon: 'lib/utils/assets/promotion.png',
      items: [
        HabitItem(title: 'Practice Music'),
        HabitItem(title: 'Self-Care Routine'),
        HabitItem(title: 'Watch Educational Videos'),
        HabitItem(title: 'Complete a Course'),
      ],
    ),

    // Housekeeping
    HabitCategory(
      name: 'Housekeeping',
      icon: 'lib/utils/assets/vacuum-cleaner.png',
      items: [
        HabitItem(title: 'Clean a Room'),
        HabitItem(title: 'Organize Closet'),
        HabitItem(title: 'Do Laundry'),
        HabitItem(title: 'Declutter'),
      ],
    ),
  ].obs;

  void toggleHabitCompletion(int categoryIndex, int itemIndex) {
    categories[categoryIndex].items[itemIndex].completed =
    !categories[categoryIndex].items[itemIndex].completed;
    categories.refresh();
  }
  void resetAllHabits() {
    for (var category in categories) {
      for (var item in category.items) {
        item.completed = false;
      }
    }
    categories.refresh(); // Notify the UI to update
  }

}
