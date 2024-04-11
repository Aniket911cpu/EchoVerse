// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBZLp0GKlwhrFBjRIEELxCvyVGj49_1VYw',
    appId: '1:476849697961:web:c6f7df346b69ce674f65b8',
    messagingSenderId: '476849697961',
    projectId: 'myallapp-f9c13',
    authDomain: 'myallapp-f9c13.firebaseapp.com',
    databaseURL: 'https://myallapp-f9c13.firebaseio.com',
    storageBucket: 'myallapp-f9c13.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBZLp0GKlwhrFBjRIEELxCvyVGj49_1VYw',
    appId: '1:476849697961:android:af4445d0d3f259b94f65b8',
    messagingSenderId: '476849697961',
    projectId: 'myallapp-f9c13',
    databaseURL: 'https://myallapp-f9c13.firebaseio.com',
    storageBucket: 'myallapp-f9c13.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC0niRJ-IwJYZMVt5cqNl1WRbdsXCbejrw',
    appId: '1:476849697961:ios:39f8d71603df055b4f65b8',
    messagingSenderId: '476849697961',
    projectId: 'myallapp-f9c13',
    databaseURL: 'https://myallapp-f9c13.firebaseio.com',
    storageBucket: 'myallapp-f9c13.appspot.com',
    androidClientId: '476849697961-08vg4odg40kc6pgs3intv40pbbppd068.apps.googleusercontent.com',
    iosClientId: '476849697961-hmmhjutkkjilcng8dgj5gu49tuuob4sq.apps.googleusercontent.com',
    iosBundleId: 'com.divinetechs.dtradio',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC0niRJ-IwJYZMVt5cqNl1WRbdsXCbejrw',
    appId: '1:476849697961:ios:39f8d71603df055b4f65b8',
    messagingSenderId: '476849697961',
    projectId: 'myallapp-f9c13',
    databaseURL: 'https://myallapp-f9c13.firebaseio.com',
    storageBucket: 'myallapp-f9c13.appspot.com',
    androidClientId: '476849697961-08vg4odg40kc6pgs3intv40pbbppd068.apps.googleusercontent.com',
    iosClientId: '476849697961-hmmhjutkkjilcng8dgj5gu49tuuob4sq.apps.googleusercontent.com',
    iosBundleId: 'com.divinetechs.dtradio',
  );
}
