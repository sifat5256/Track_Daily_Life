class HabitCategory {
  final String name;
  final String icon;
  final List<HabitItem> items;
  double get progress => items.where((item) => item.completed).length / items.length;

  HabitCategory({required this.name, required this.icon, required this.items});
}

class HabitItem {
  String title;
  bool completed;

  HabitItem({required this.title, this.completed = false});
}
