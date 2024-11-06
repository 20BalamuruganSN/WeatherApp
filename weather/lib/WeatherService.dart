import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String _apiKey = 'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={023640d1d80ef45579a5429624fe3e5e}'; // Replace with your OpenWeatherMap API key

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body); // Return decoded JSON as a Map
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather: $e');
    }
  }
}
