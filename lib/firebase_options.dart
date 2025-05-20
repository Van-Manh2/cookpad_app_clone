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
    apiKey: 'AIzaSyDfNnQuW_fuxOL8OJc8tefZHXuq_59M_mg',
    appId: '1:1023988252381:web:6007047f75c477f5e1a534',
    messagingSenderId: '1023988252381',
    projectId: 'cookpab-a0bf8',
    authDomain: 'cookpab-a0bf8.firebaseapp.com',
    databaseURL: 'https://cookpab-a0bf8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cookpab-a0bf8.firebasestorage.app',
    measurementId: 'G-8M6S15T09G',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFW7v8pVap4T_HR6xS71Y2do9XOmB2m5c',
    appId: '1:1023988252381:android:93539f6ce25e466fe1a534',
    messagingSenderId: '1023988252381',
    projectId: 'cookpab-a0bf8',
    databaseURL: 'https://cookpab-a0bf8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cookpab-a0bf8.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaCqgWzNlXkU9qmNCFIBlyaK1pblQbkr8',
    appId: '1:1023988252381:ios:0056005c6e48fc96e1a534',
    messagingSenderId: '1023988252381',
    projectId: 'cookpab-a0bf8',
    databaseURL: 'https://cookpab-a0bf8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cookpab-a0bf8.firebasestorage.app',
    androidClientId: '1023988252381-j72sovejp1tdv2d12g414td6q4bhf30m.apps.googleusercontent.com',
    iosClientId: '1023988252381-07s5c46joqom2tvfe2t5ecj6q99jr1im.apps.googleusercontent.com',
    iosBundleId: 'com.example.cookpadAppClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDaCqgWzNlXkU9qmNCFIBlyaK1pblQbkr8',
    appId: '1:1023988252381:ios:0056005c6e48fc96e1a534',
    messagingSenderId: '1023988252381',
    projectId: 'cookpab-a0bf8',
    databaseURL: 'https://cookpab-a0bf8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cookpab-a0bf8.firebasestorage.app',
    androidClientId: '1023988252381-j72sovejp1tdv2d12g414td6q4bhf30m.apps.googleusercontent.com',
    iosClientId: '1023988252381-07s5c46joqom2tvfe2t5ecj6q99jr1im.apps.googleusercontent.com',
    iosBundleId: 'com.example.cookpadAppClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDfNnQuW_fuxOL8OJc8tefZHXuq_59M_mg',
    appId: '1:1023988252381:web:58f0705832dc5873e1a534',
    messagingSenderId: '1023988252381',
    projectId: 'cookpab-a0bf8',
    authDomain: 'cookpab-a0bf8.firebaseapp.com',
    databaseURL: 'https://cookpab-a0bf8-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'cookpab-a0bf8.firebasestorage.app',
    measurementId: 'G-F7F5PXQ0TJ',
  );

}