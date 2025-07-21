import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.teal.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Logo/Icon with decorative container
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.teal.shade300, width: 2),
                ),
                child: Icon(
                  Icons.explore,
                  size: 60,
                  color: Colors.teal.shade700,
                ),
              ),
              SizedBox(height: 20),
              
              // App Name with creative text style
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                  children: [
                    TextSpan(text: "What's "),
                    TextSpan(
                      text: "Around",
                      style: TextStyle(
                        color: Colors.teal.shade700,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    TextSpan(text: " Me?"),
                  ],
                ),
              ),
              
              SizedBox(height: 10),
              
              // Version badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // About content in card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Discover the world around you!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Our app helps you explore nearby places, find interesting locations, and discover hidden gems in your vicinity.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 30),
              
              // Team info with icons
              Text(
                "Developed with ❤️ by",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "GeoSeekers Team",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              SizedBox(height: 15),
              
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  _buildTeamIcon(Icons.code, "Developers"),
                  _buildTeamIcon(Icons.design_services, "Designers"),
                  _buildTeamIcon(Icons.school, "Students"),
                  _buildTeamIcon(Icons.location_on, "Explorers"),
                ],
              ),
              
              SizedBox(height: 30),
              
              // Project info
              Text(
                "UiTM Mobile Programming Project",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "© ${DateTime.now().year} All Rights Reserved",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamIcon(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.teal.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.teal.shade700),
        ),
        SizedBox(height: 5),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}