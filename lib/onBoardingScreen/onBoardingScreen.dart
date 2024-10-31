import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../modules/home/view/main_home_screen.dart';

class OnboardingPage extends StatelessWidget {
  final String name; // Add a name variable to pass user data

  OnboardingPage({Key? key, required this.name}) : super(key: key); // Constructor

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Welcome",
          body: "This is the first page of the introduction screen.",
          image: Center(child: Icon(Icons.abc, size: 100)),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        PageViewModel(
          title: "Easy to Use",
          body: "This app is easy to use and navigate.",
          image: Center(child: Icon(Icons.accessibility, size: 100)),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
          ),
        ),
        PageViewModel(
          title: "Get Started",
          body: "Let’s get started!",
          image: Center(child: Icon(Icons.start, size: 100)),
          decoration: PageDecoration(
            titleTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 18),
          ),
        ),
      ],
      onDone: () {
        // Pass the user's name to the MainHomeScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainHomeScreen(name: name)),
        );
      },
      onSkip: () {
        // Pass the user's name to the MainHomeScreen when skipped
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => MainHomeScreen(name: name)),
        );
      },
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
        size: Size.square(8.0),
        activeSize: Size(16.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
      ),
    );
  }
}
