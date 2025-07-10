import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'directions_service.dart';

class PlaceDetailPage extends StatelessWidget {
  final Map place;

  const PlaceDetailPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    double destLat = place["lat"];
    double destLng = place["lng"];
    DirectionsService directionsService = DirectionsService();

    return Scaffold(
      appBar: AppBar(
        title: Text(place["name"]),
      ),
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
              onPressed: () async {
                Position currentPosition = await Geolocator.getCurrentPosition();

                var directions = await directionsService.getDirections(
                  currentPosition.latitude,
                  currentPosition.longitude,
                  destLat,
                  destLng,
                );

                if (directions != null) {
                  var route = directions["routes"][0];
                  var leg = route["legs"][0];
                  print("Distance: ${leg["distance"]["text"]}, Duration: ${leg["duration"]["text"]}");
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
