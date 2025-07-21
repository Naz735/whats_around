import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailPage extends StatelessWidget {
  final Map place;

  PlaceDetailPage({required this.place});

  Future<void> _getDirections(BuildContext context) async {
    try {
      // Get current position
      Position currentPosition = await Geolocator.getCurrentPosition();

      // Build Google Maps directions URL
      final double destLat = place["lat"];
      final double destLng = place["lng"];
      final url = Uri.parse(
        "https://www.google.com/maps/dir/?api=1"
        "&origin=${currentPosition.latitude},${currentPosition.longitude}"
        "&destination=$destLat,$destLng"
        "&travelmode=driving"
      );

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open Google Maps")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place["name"])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${place["name"]}", style: TextStyle(fontSize: 18)),
            Text("Address: ${place["vicinity"]}", style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.directions),
              label: Text("Get Directions"),
              onPressed: () => _getDirections(context),
            ),
          ],
        ),
      ),
    );
  }
}