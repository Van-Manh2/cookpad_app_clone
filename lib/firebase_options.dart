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
    apiKey: 'AIzaSyDcdheE8cufW0160mLGq591DF15WFy04t8',
    appId: '1:700048731890:web:41fb364e3767f664b16a6b',
    messagingSenderId: '700048731890',
    projectId: 'cookpad-app-clone-c8f24',
    authDomain: 'cookpad-app-clone-c8f24.firebaseapp.com',
    storageBucket: 'cookpad-app-clone-c8f24.firebasestorage.app',
    measurementId: 'G-EV8HLCBQ05',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTE58ooaxXRCo5_dQbaVYvYvzHE6ZLCBU',
    appId: '1:700048731890:android:bd29685498acbee6b16a6b',
    messagingSenderId: '700048731890',
    projectId: 'cookpad-app-clone-c8f24',
    storageBucket: 'cookpad-app-clone-c8f24.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBt6xo9psdBw2csvRke27jAuSgBzMROJTw',
    appId: '1:700048731890:ios:3d1f19938db926aeb16a6b',
    messagingSenderId: '700048731890',
    projectId: 'cookpad-app-clone-c8f24',
    storageBucket: 'cookpad-app-clone-c8f24.firebasestorage.app',
    iosBundleId: 'com.example.cookpadAppClone',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBt6xo9psdBw2csvRke27jAuSgBzMROJTw',
    appId: '1:700048731890:ios:3d1f19938db926aeb16a6b',
    messagingSenderId: '700048731890',
    projectId: 'cookpad-app-clone-c8f24',
    storageBucket: 'cookpad-app-clone-c8f24.firebasestorage.app',
    iosBundleId: 'com.example.cookpadAppClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDcdheE8cufW0160mLGq591DF15WFy04t8',
    appId: '1:700048731890:web:8e3cefc4d2a43814b16a6b',
    messagingSenderId: '700048731890',
    projectId: 'cookpad-app-clone-c8f24',
    authDomain: 'cookpad-app-clone-c8f24.firebaseapp.com',
    storageBucket: 'cookpad-app-clone-c8f24.firebasestorage.app',
    measurementId: 'G-FHY9LYN566',
  );
}
