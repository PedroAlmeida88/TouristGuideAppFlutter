import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tp_flutter/firebase_options.dart';
import 'package:tp_flutter/utils/shared_preferences.dart';
import 'my_app.dart';


void initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

void main() {
  // Ensure that Flutter is initialized before Firebase
  WidgetsFlutterBinding.ensureInitialized();
  sharedPrefs.initSharedPreferences();
  initFirebase();
  runApp(const MyApp());
}



