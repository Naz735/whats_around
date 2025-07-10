import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          ListTile(
            title: Text("Dark Mode"),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                // Implement dark mode toggle logic if needed later
              },
            ),
          ),
        ],
      ),
    );
  }
}
