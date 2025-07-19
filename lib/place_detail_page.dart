import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceDetailPage extends StatelessWidget {
  final Map place;
  final String apiKey = "YOUR_REAL_API_KEY"; // replace with valid key

  PlaceDetailPage({required this.place});

  Future<void> _getDirections(BuildContext context) async {
    Position currentPosition = await Geolocator.getCurrentPosition();
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json"
      "?origin=${currentPosition.latitude},${currentPosition.longitude}"
      "&destination=${place["lat"]},${place["lng"]}"
      "&key=$apiKey",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK" && data["routes"].isNotEmpty) {
        var leg = data["routes"][0]["legs"][0];
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Route Info"),
            content: Text("Distance: ${leg["distance"]["text"]}, Duration: ${leg["duration"]["text"]}"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("OK"),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("No directions found")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to get directions")),
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
