import 'package:get/get.dart';

class ResponsiveText {
  // Define a function to calculate text size based on screen width
  static double textSize(double size) {
    // Adjust the text size based on the screen width
    return size * Get.width / 375; // 375 is the reference width (can be any base size)
  }
}
