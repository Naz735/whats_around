import 'dart:convert';
import 'package:http/http.dart' as http;

class DirectionsService {
  // Use your actual API key here (same as HomeScreen)
  static const String _apiKey = "AIzaSyBlmSxe2OE1EyYQPhm1jqZzPkvUZzR1l3o";

  Future<Map<String, dynamic>?> getDirections(
      double originLat, double originLng, double destLat, double destLng) async {
    final url = Uri.parse(
      "https://maps.googleapis.com/maps/api/directions/json"
      "?origin=$originLat,$originLng"
      "&destination=$destLat,$destLng"
      "&key=$_apiKey",
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}