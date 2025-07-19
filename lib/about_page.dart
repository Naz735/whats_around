import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("What's Around Me?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Version: 1.0.0", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text("Developed by GeoSeekers for UiTM Mobile Programming project."),
          ],
        ),
      ),
    );
  }
}
