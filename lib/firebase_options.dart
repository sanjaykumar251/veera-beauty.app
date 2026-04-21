// ─────────────────────────────────────────────────────────────────────────────
// IMPORTANT: Replace ALL placeholder values below with your actual Firebase
// project configuration. To get these values:
// 1. Go to https://console.firebase.google.com
// 2. Create a new project named "veeras-beauty"
// 3. Add an Android app with package name: com.veeras.veeras_beauty
// 4. Download google-services.json → place at: android/app/google-services.json
// 5. Run: flutterfire configure (to auto-generate this file)
// ─────────────────────────────────────────────────────────────────────────────

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android: return android;
      case TargetPlatform.iOS: return ios;
      default: throw UnsupportedError('Firebase not configured for this platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiZuc6CQVgA7UfSFJBqfPF_Npey0IFSs0',
    appId: '1:930869727200:android:6549809d21aa08b70c6585',
    messagingSenderId: '930869727200',
    projectId: 'veeras-beauty-app',
    storageBucket: 'veeras-beauty-app.firebasestorage.app',
  );

  // Replace with your actual values from Firebase Console

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: '1:YOUR_PROJECT_NUMBER:ios:YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'veeras-beauty',
    storageBucket: 'veeras-beauty.appspot.com',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.veeras.veeras_beauty',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: '1:YOUR_PROJECT_NUMBER:web:YOUR_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'veeras-beauty',
    storageBucket: 'veeras-beauty.appspot.com',
    authDomain: 'veeras-beauty.firebaseapp.com',
  );
}
