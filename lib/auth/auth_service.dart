
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:track_daily_life/auth/log_in.dart';
import 'package:track_daily_life/home_screen.dart';

import '../modules/home/view/main_home_screen.dart';
import 'logIn.dart';



class AuthController extends GetxController {
  // Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observing user state with GetX
  var firebaseUser = Rxn<User>();

  // On initialization, check if the user is already logged in
  @override
  void onReady() {
    super.onReady();
    firebaseUser.bindStream(_auth.authStateChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  // Set initial screen based on user authentication state
  _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginPage());
    } else {
      String name = user.displayName ?? "User";
      Get.offAll(() => MainHomeScreen(name: user.displayName ?? 'User'));
    }
  }

  // Sign up
  Future<User?> signUp(String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(name);
        await user.reload(); // Ensure display name is updated
        return user;
      }
    } catch (e) {
      Get.snackbar('Error', 'Sign Up Failed: $e');
    }
    return null;
  }

  // Login
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      Get.snackbar('Error', 'Login Failed: $e');
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
