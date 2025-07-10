import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  Position? currentPosition;
  String selectedCategory = "all";
  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> allPlaces = [];
  List<Map<String, dynamic>> displayedPlaces = [];
  final String apiKey = "AIzaSyBlmSxe2OE1EyYQPhm1jqZzPkvUZzR1l3o"; // replace with your API key

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    currentPosition = await Geolocator.getCurrentPosition();
    setState(() {});
    _fetchPlaces("restaurant");
  }

  Future<void> _fetchPlaces(String category) async {
    if (currentPosition == null) return;

    String typeParam = category == "all" ? "" : "&type=$category";
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
      "?location=${currentPosition!.latitude},${currentPosition!.longitude}"
      "&radius=1500"
      "$typeParam"
      "&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        setState(() {
          allPlaces = List<Map<String, dynamic>>.from(data["results"].map((place) {
            return {
              "name": place["name"],
              "lat": place["geometry"]["location"]["lat"],
              "lng": place["geometry"]["location"]["lng"],
              "vicinity": place["vicinity"] ?? "",
            };
          }));
          displayedPlaces = List.from(allPlaces);
        });
      } else {
        print("Places API error: ${data["status"]}");
      }
    } else {
      print("Failed to fetch places");
    }
  }

  void _searchPlaces(String query) {
    query = query.toLowerCase();
    setState(() {
      displayedPlaces = allPlaces.where((place) {
        return place["name"].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _bookmarkPlace(Map<String, dynamic> place) async {
    // TODO: Save bookmark to SQLite database here
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${place["name"]} bookmarked!")));
  }

  Future<void> _openMaps(double lat, double lng) async {
    String googleMapsUrl = "https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  void _filterCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    if (category == "all") {
      setState(() {
        displayedPlaces = List.from(allPlaces);
      });
    } else {
      _fetchPlaces(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text("What's Around Me?"),
        backgroundColor: isDark ? Colors.grey[900] : Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Settings coming soon")));
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: _searchPlaces,
              decoration: InputDecoration(
                hintText: "Search places by name...",
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
                CategoryButton(icon: Icons.all_inclusive, label: "All", onTap: () => _filterCategory("all")),
                CategoryButton(icon: Icons.restaurant, label: "Food", onTap: () => _filterCategory("restaurant")),
                CategoryButton(icon: Icons.local_gas_station, label: "Gas", onTap: () => _filterCategory("gas_station")),
                CategoryButton(icon: Icons.atm, label: "ATM", onTap: () => _filterCategory("atm")),
                CategoryButton(icon: Icons.local_pharmacy, label: "Pharmacy", onTap: () => _filterCategory("pharmacy")),
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
                      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
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
              itemCount: displayedPlaces.length,
              itemBuilder: (context, index) {
                var place = displayedPlaces[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ListTile(
                    leading: Icon(Icons.place, color: isDark ? Colors.white : Colors.blue),
                    title: Text(place["name"]),
                    subtitle: Text(place["vicinity"]),
                    trailing: IconButton(
                      icon: Icon(Icons.bookmark),
                      onPressed: () => _bookmarkPlace(place),
                    ),
                    onTap: () {
                      _openMaps(place["lat"], place["lng"]);
                    },
                  ),
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
  final VoidCallback onTap;

  CategoryButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
