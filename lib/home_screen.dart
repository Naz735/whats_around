import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> places = [
      {"name": "KFC", "distance": "0.5 km"},
      {"name": "Shell", "distance": "0.8 km"},
      {"name": "Watsons", "distance": "1.1 km"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("What's Around Me?"),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "ATM / Food / Pharmacy...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          // Category Buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                CategoryButton(icon: Icons.fastfood, label: "Makanan"),
                CategoryButton(icon: Icons.local_gas_station, label: "Gas"),
                CategoryButton(icon: Icons.atm, label: "ATM"),
                CategoryButton(icon: Icons.local_pharmacy, label: "Farmasi"),
              ],
            ),
          ),

          // Google Map Integration
          currentPosition == null
              ? CircularProgressIndicator()
              : Container(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentPosition!.latitude,
                          currentPosition!.longitude),
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),

          // List of Nearby Places
          Expanded(
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(Icons.place),
                  title: Text(places[index]["name"]!),
                  trailing: Text(places[index]["distance"]!),
                  onTap: () {
                    // To be implemented: navigate to Detail page
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final IconData icon;
  final String label;

  CategoryButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton.icon(
        onPressed: () {
          // Handle category selection
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
