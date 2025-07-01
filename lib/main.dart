import 'package:flutter/material.dart';
import 'home_screen.dart'; // Adjust path if your file is under lib/screens/home_screen.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "What's Around Me?",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // ✅ This shows your app instead of demo counter
    );
  }
}
