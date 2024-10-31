// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC--eXg_i0s47t1mnq8K1ujlttO4OxCrEk',
    appId: '1:754316105310:web:4eae4ccf73d1602d55c6cf',
    messagingSenderId: '754316105310',
    projectId: 'trackyourdailylife',
    authDomain: 'trackyourdailylife.firebaseapp.com',
    storageBucket: 'trackyourdailylife.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjDEtFlS_WRs10c5Oues-fZLZWXaaQx7g',
    appId: '1:754316105310:android:26c3b3d759b95d4755c6cf',
    messagingSenderId: '754316105310',
    projectId: 'trackyourdailylife',
    storageBucket: 'trackyourdailylife.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDcbEzghokszaH7Zim93L9LKttOMADDeS8',
    appId: '1:754316105310:ios:6b62f8d892c5ae4e55c6cf',
    messagingSenderId: '754316105310',
    projectId: 'trackyourdailylife',
    storageBucket: 'trackyourdailylife.appspot.com',
    iosBundleId: 'com.example.trackDailyLife',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDcbEzghokszaH7Zim93L9LKttOMADDeS8',
    appId: '1:754316105310:ios:6b62f8d892c5ae4e55c6cf',
    messagingSenderId: '754316105310',
    projectId: 'trackyourdailylife',
    storageBucket: 'trackyourdailylife.appspot.com',
    iosBundleId: 'com.example.trackDailyLife',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC--eXg_i0s47t1mnq8K1ujlttO4OxCrEk',
    appId: '1:754316105310:web:bb55ed4aaafdb64555c6cf',
    messagingSenderId: '754316105310',
    projectId: 'trackyourdailylife',
    authDomain: 'trackyourdailylife.firebaseapp.com',
    storageBucket: 'trackyourdailylife.appspot.com',
  );
}
