import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBqE3p0BulB4utyngcHYyIGzQAYa4iJUiU",
            authDomain: "proinsider-be532.firebaseapp.com",
            projectId: "proinsider-be532",
            storageBucket: "proinsider-be532.firebasestorage.app",
            messagingSenderId: "348000790844",
            appId: "1:348000790844:web:68f5b25852402cd81d5639",
            measurementId: "G-S4HS1XYLZK"));
  } else {
    await Firebase.initializeApp();
  }
}
