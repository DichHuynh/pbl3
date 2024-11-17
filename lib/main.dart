import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pbl3/source/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb){
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDxwIDck2MgwpKZxlfabVjDWt9tzesk43c",
    authDomain: "infras-management-a9ba8.firebaseapp.com",
    projectId: "infras-management-a9ba8",
    storageBucket: "infras-management-a9ba8.firebasestorage.app",
    messagingSenderId: "579691635333",
    appId: "1:579691635333:web:4cf1ac611496e4802e7fec",
    measurementId: "G-4MP77MS4F1"
      )
    );
  } else{
    await Firebase.initializeApp(); 
  }
  
  runApp(const MyApp());
}
