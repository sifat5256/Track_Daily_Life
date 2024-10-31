//
// import 'package:get/get.dart';
//
// import 'dart:convert';
//
// class PrayerTimesController extends GetxController {
//   var prayerTimes = {}.obs;
//   var isLoading = true.obs;
//   var errorMessage = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     fetchPrayerTimes();
//   }
//
//   Future<void> fetchPrayerTimes() async {
//     try {
//       isLoading(true);
//       errorMessage('');
//       Position position = await _determinePosition();
//       final times = await _getPrayerTimes(position.latitude, position.longitude);
//       prayerTimes.value = times;
//     } catch (e) {
//       errorMessage(e.toString());
//     } finally {
//       isLoading(false);
//     }
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw 'Location services are disabled.';
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw 'Location permissions are denied';
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw 'Location permissions are permanently denied';
//     }
//
//     return await Geolocator.getCurrentPosition();
//   }
//
//   Future<Map<String, dynamic>> _getPrayerTimes(double latitude, double longitude) async {
//     final response = await http.get(Uri.parse(
//         'https://api.aladhan.com/v1/timings?latitude=$latitude&longitude=$longitude&method=2'));
//     if (response.statusCode == 200) {
//       return json.decode(response.body)['data']['timings'];
//     } else {
//       throw 'Failed to load prayer times';
//     }
//   }
// }
