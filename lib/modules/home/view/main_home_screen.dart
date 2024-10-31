
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../auth/auth_service.dart';
import '../../../helpers/responsive_sizing.dart';
import '../../../helpers/responsive_text_size.dart';
import '../../expense_tracker/view/sxpense_home_screen.dart';
import '../../notes/views/note_home_screen.dart';
import '../../to_do/view/to_do_home_screen.dart';


class MainHomeScreen extends StatelessWidget {
  final String name;
  MainHomeScreen({super.key,  required this.name});
   final AuthController authController = Get.find();

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  //
  // Future<void> _logout(BuildContext context) async {
  //   try {
  //     await _auth.signOut();
  //     // After sign out, navigate to the LoginScreen
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => LoginScreen()),
  //           (Route<dynamic> route) => false,
  //     );
  //   } catch (e) {
  //     print('Logout Failed: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // Get the current date and day
    final now = DateTime.now();
    final formattedDate = DateFormat('MMMM d, yyyy').format(now);
    final formattedDay = DateFormat('EEEE').format(now);

    return Scaffold(
      backgroundColor: Colors.greenAccent.shade100,
      body: Column(
        children: [

          _buildHeader(context, formattedDate, formattedDay),
          const SizedBox(height: 40),
          _buildMainButtons(context),
          const Divider(indent: 20, endIndent: 20),
          const SizedBox(height: 50),

          Text(
            "Prayer time, Sunrise, and Sunset time",
            style: TextStyle(
                fontSize: ResponsiveText.textSize(20),
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
         // Expanded(child: PrayerTimesWidget()), // Ensure the widget is responsive
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String formattedDate, String formattedDay) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: MediaQuery.of(context).size.height * 0.13,
      color: Colors.green,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Row(
                children: [
                  SizedBox(width: 4),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "$name!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: Colors.black),
                onPressed: () => authController.logout()
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildButton(
            context,
            "Expense Tracker",
            "lib/utils/assets/accounting.png",
            Colors.indigo,
                () => Get.to(
                  () => ExpenseHomeScreen(),
              transition: Transition.rightToLeftWithFade,
              duration: const Duration(milliseconds: 500),  // Adjust the time as needed
            )
          // Use GetX for navigation
        ),
        _buildButton(
          context,
          "To-Do",
          "lib/utils/assets/checklist.png",
          Colors.blueGrey,
              () => Get.to(() => ToDoHomePage(), transition: Transition.rightToLeftWithFade),
        ),
        _buildButton(
          context,
          "Notes",
          "lib/utils/assets/sticky-note.png",
          Colors.deepOrangeAccent,
              () => Get.to(() => NotesHomePage(), transition: Transition.rightToLeftWithFade,),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, String label, String assetPath, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(

        width: ResponsiveSize.width(100),
        height: ResponsiveSize.height(100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              assetPath,
              width: ResponsiveSize.width(50), // Example width
              height: ResponsiveSize.height(50), // Example height
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style:  TextStyle(
                fontSize: ResponsiveText.textSize(12),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
