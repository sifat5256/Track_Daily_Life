

import 'package:get/get.dart';

import '../modules/to_do/view/to_do_home_screen.dart';



// Auto-generated file for better route management

class AppRoutes {
  static const home = '/';
  static const toDo = '/to_do';
  static const notes = '/notes';
  static const expenseTracker = '/expense_tracker';

}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => ToDoHomePage(),
      transition: Transition.fadeIn, // Fade-in transition for the home screen
    ),
    // GetPage(
    //   name: AppRoutes.toDo,
    //   page: () => ToDoView(),
    //   transition: Transition.rightToLeftWithFade, // Slide-in from right with fade
    //   transitionDuration: Duration(milliseconds: 500), // Customize duration
    // ),
    // GetPage(
    //   name: AppRoutes.notes,
    //   page: () => NotesView(),
    //   transition: Transition.leftToRightWithFade, // Slide-in from left with fade
    //   transitionDuration: Duration(milliseconds: 500),
    // ),
    // GetPage(
    //   name: AppRoutes.expenseTracker,
    //   page: () => ExpenseTrackerView(),
    //   transition: Transition.downToUp, // Slide-up transition for the expense tracker
    //   transitionDuration: Duration(milliseconds: 500),
    // ),

  ];
}
