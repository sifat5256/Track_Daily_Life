import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:track_daily_life/auth/auth_service.dart';
import 'package:track_daily_life/auth/log_in.dart';
import 'package:track_daily_life/home_screen.dart';
import 'package:track_daily_life/modules/habit_Track/view/habit_home.dart';

import 'auth/logIn.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Initialize AuthController with GetX
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Organize',
      debugShowCheckedModeBanner: false,
      home: LoginPage()

     // home: HabitTrackerGrid() ,
    );
  }
}