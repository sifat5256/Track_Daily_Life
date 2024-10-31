//
// import 'package:daily_organizer_app/modules/prayer_times/controllers/prayer_time_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
//
// class PrayerTimesWidget extends StatelessWidget {
//   final PrayerTimesController controller = Get.put(PrayerTimesController());
//
//   @override
//   Widget build(BuildContext context) {
//     List<String> orderedKeys = [
//       'Sunset', 'Sunrise', 'Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha', 'Midnight', 'First Third', 'Last Third'
//     ];
//
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.green,
//         child: const Icon(Icons.refresh),
//         onPressed: () => controller.fetchPrayerTimes(),
//       ),
//       body: Container(
//
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.only(topLeft: Radius.circular(16),topRight:  Radius.circular(16),),
//           gradient: LinearGradient(
//             colors: [Colors.blueGrey.shade900, Colors.blueGrey.shade600],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Obx(() {
//           if (controller.isLoading.value) {
//             return const Center(child: CircularProgressIndicator());
//           }
//
//           if (controller.errorMessage.isNotEmpty) {
//             return Center(child: Text(controller.errorMessage.value, style: TextStyle(color: Colors.white)));
//           }
//
//           return GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: _getCrossAxisCount(context), // Responsive grid
//               childAspectRatio: _getAspectRatio(context), // Responsive aspect ratio
//               mainAxisSpacing: 12,
//               crossAxisSpacing: 12,
//             ),
//             padding: const EdgeInsets.all(12),
//             itemCount: orderedKeys.length,
//             itemBuilder: (context, index) {
//               String key = orderedKeys[index];
//               String time = controller.prayerTimes[key] ?? 'N/A';
//
//               Color cardColor;
//               if (['Sunset', 'Sunrise'].contains(key)) {
//                 cardColor = Colors.blueGrey.shade700; // Color for Sunset and Sunrise
//               } else if (['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'].contains(key)) {
//                 cardColor = Colors.indigo.shade700; // Color for prayer times
//               } else {
//                 cardColor = Colors.orange.shade700; // Color for others
//               }
//
//               return GestureDetector(
//                 onTap: () {
//                   // You can add an action here if needed
//                 },
//                 child: AnimatedScale(
//                   duration: const Duration(milliseconds: 200),
//                   scale: 1.0,
//                   child: Card(
//
//                     color: cardColor.withOpacity(0.9),
//                     elevation: 6,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             key,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             time,
//                             style: const TextStyle(fontSize: 14, color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         }),
//       ),
//     );
//   }
//
//   // Responsive column count based on screen size
//   int _getCrossAxisCount(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth >= 1200) {
//       return 4; // 4 items per row on very large screens
//     } else if (screenWidth >= 800) {
//       return 3; // 3 items per row on medium screens
//     } else if (screenWidth >= 400) {
//       return 3; // 2 items per row on tablets and smaller laptops
//     } else {
//       return 2; // 2 items per row on mobile screens
//     }
//   }
//
//   // Adjust the aspect ratio to control the height of the grid items
//   double _getAspectRatio(BuildContext context) {
//     double screenWidth = MediaQuery.of(context).size.width;
//     if (screenWidth >= 1200) {
//       return 3; // Wider aspect ratio for very large screens
//     } else if (screenWidth >= 600) {
//       return 1.8; // Aspect ratio for tablets
//     } else {
//       return 1.4; // Slightly squarer ratio for phones
//     }
//   }
// }
