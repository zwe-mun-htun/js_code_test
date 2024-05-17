// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyCoBxUm000mjsQI5w-lhfp_esvSuET-7OA",
      authDomain: "wemo-b1073.firebaseapp.com",
      databaseURL: "https://wemo-b1073.firebaseio.com",
      projectId: "wemo-b1073",
      storageBucket: "wemo-b1073.appspot.com",
      messagingSenderId: "40206010070",
      appId: "1:40206010070:web:7c9dd022b62e14e88eab77",
      measurementId: "G-KC0HLD1CG7");
}
