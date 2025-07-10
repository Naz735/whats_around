import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectionsService {
  // Your actual API key
  final String apiKey = "AIzaSyBlmSxe2OE1EyYQPhm1jqZzPkvUZzR1l3o";

  Future<Map<String, dynamic>?> getDirections(
      double originLat, double originLng, double destLat, double destLng) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json"
      "?origin=$originLat,$originLng"
      "&destination=$destLat,$destLng"
      "&mode=driving"
      "&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        return data;
      } else {
        print("Directions API error: ${data["status"]}");
      }
    } else {
      print("Failed to fetch directions");
    }

    return null;
  }

  Future<List<Map<String, dynamic>>> getNearbyPlaces(
      double lat, double lng, String keyword) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
      "?location=$lat,$lng"
      "&radius=1500"
      "&keyword=$keyword"
      "&key=$apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "OK") {
        List results = data["results"];
        return results.map((place) {
          return {
            "name": place["name"],
            "lat": place["geometry"]["location"]["lat"],
            "lng": place["geometry"]["location"]["lng"],
            "category": keyword,
            "distance": "", // distance can be calculated if needed
          };
        }).toList();
      } else {
        print("Places API error: ${data["status"]}");
      }
    } else {
      print("Failed to fetch places");
    }

    return [];
  }
}
