import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'bookmark_page.dart';
import 'settings_page.dart';
import 'feedback_page.dart';
import 'login_page.dart'; // <-- Add this import

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleDarkMode(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "What's Around Me?",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/login', // Start at login page
      routes: {
        '/login': (context) => LoginPage(), // Uses your login_page.dart
        '/': (context) => HomeScreen(isGuest: false),
        '/bookmarks': (context) => BookmarkPage(),
        '/settings': (context) => SettingsPage(
              isDarkMode: isDarkMode,
              onToggleDarkMode: toggleDarkMode,
            ),
        '/feedback': (context) => FeedbackPage(),
      },
    );
  }
}