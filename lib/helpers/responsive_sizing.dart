import 'package:get/get.dart';

class ResponsiveSize {
  // Define a function to calculate width based on screen width
  static double width(double size) {
    return size * Get.width / 375; // 375 is the reference width (can be any base size)
  }

  // Define a function to calculate height based on screen height
  static double height(double size) {
    return size * Get.height / 812; // 812 is the reference height (can be any base size)
  }
}
