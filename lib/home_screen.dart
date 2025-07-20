import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'db_helper.dart';
import 'place_detail_page.dart';

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  const HomeScreen({super.key, required this.isGuest});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = "AIzaSyBlmSxe2OE1EyYQPhm1jqZzPkvUZzR1l3o"; // 🔑 Replace with your actual API Key
  Position? currentPosition;
  List<Map<String, dynamic>> places = [];
  String selectedCategory = "restaurant";
  DBHelper dbHelper = DBHelper();
  final Completer<GoogleMapController> _mapController = Completer();

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
    _fetchPlaces(selectedCategory);
  }

  Future<void> _fetchPlaces(String category) async {
    if (currentPosition == null) return;

    String typeParam = category == "all" ? "&keyword=*" : "&type=$category";

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
          places = List<Map<String, dynamic>>.from(data["results"].map((place) {
            return {
              "name": place["name"],
              "lat": place["geometry"]["location"]["lat"],
              "lng": place["geometry"]["location"]["lng"],
              "vicinity": place["vicinity"] ?? "",
            };
          }));
        });
      }
    }
  }

  Future<void> _bookmarkPlace(Map<String, dynamic> place) async {
    if (widget.isGuest) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please login to bookmark")),
      );
      return;
    }
    await dbHelper.insertFavorite({
      'name': place["name"],
      'lat': place["lat"],
      'lng': place["lng"],
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${place["name"]} bookmarked!")),
    );
  }

  void _filterCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    _fetchPlaces(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("What's Around Me?")),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Menu", style: TextStyle(fontSize: 24, color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text("Bookmarks"),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                if (widget.isGuest) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please login to access bookmarks")),
                  );
                } else {
                  Navigator.pushNamed(context, '/bookmarks');
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔵 Map
                Container(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(currentPosition!.latitude, currentPosition!.longitude),
                      zoom: 14,
                    ),
                    markers: places
                        .map((place) => Marker(
                              markerId: MarkerId(place["name"]),
                              position: LatLng(place["lat"], place["lng"]),
                              infoWindow: InfoWindow(title: place["name"]),
                            ))
                        .toSet(),
                    onMapCreated: (controller) {
                      _mapController.complete(controller);
                    },
                  ),
                ),

                // 🔵 Filter Buttons
                Container(
                  color: Colors.grey[200],
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
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
                ),

                // 🔵 List of Places with Pull-to-Refresh
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => _fetchPlaces(selectedCategory),
                    child: places.isEmpty
                        ? ListView(
                            children: [
                              SizedBox(
                                height: 400,
                                child: Center(child: Text("No places found")),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              var place = places[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: ListTile(
                                  leading: Icon(Icons.place),
                                  title: Text(place["name"]),
                                  subtitle: Text(place["vicinity"]),
                                  trailing: IconButton(
                                    icon: Icon(Icons.bookmark),
                                    onPressed: () => _bookmarkPlace(place),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaceDetailPage(place: place),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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

  const CategoryButton({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton.icon(
        icon: Icon(icon),
        label: Text(label),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      ),
    );
  }
}
