import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleDarkMode;

  const SettingsPage({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text("Dark Mode"),
            value: isDarkMode,
            onChanged: onToggleDarkMode,
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "What's Around Me?",
                applicationVersion: "1.0.0",
                applicationLegalese: "© 2025 Your Name",
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback),
            title: Text("Feedback"),
            onTap: () {
              Navigator.pushNamed(context, '/feedback');
            },
          ),
        ],
      ),
    );
  }
}
