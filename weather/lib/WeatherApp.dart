import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:flutter/material.dart';
import 'WeatherService.dart';
import 'WeatherDatabase.dart';

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final WeatherService _weatherService = WeatherService();
  final WeatherDatabase _weatherDatabase = WeatherDatabase();

  final TextEditingController _cityController = TextEditingController();
  String _temperature = '';
  String _condition = '';

  void _getWeather() async {
    final city = _cityController.text;
    final weatherData = await _weatherService.fetchWeather(city);

    setState(() {
      _temperature = weatherData['main']['temp'].toString();
      _condition = weatherData['weather'][0]['description'];
    });

    // Save to Firestore
    await _weatherDatabase.saveWeatherData(city, weatherData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(labelText: 'Enter City Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getWeather,
              child: Text('Get Weather'),
            ),
            SizedBox(height: 20),
            if (_temperature.isNotEmpty && _condition.isNotEmpty)
              Column(
                children: [
                  Text('Temperature: $_temperature°C', style: TextStyle(fontSize: 20)),
                  Text('Condition: $_condition', style: TextStyle(fontSize: 20)),
                ],
              ),
            Expanded(
              child: StreamBuilder<firestore.QuerySnapshot>(
                stream: _weatherDatabase.getWeatherData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No weather data available.'));
                  }
                  final weatherDocs = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: weatherDocs.length,
                    itemBuilder: (context, index) {
                      final data = weatherDocs[index];
                      return ListTile(
                        title: Text(data['city']),
                        subtitle: Text('${data['temperature']}°C, ${data['condition']}'),
                        trailing: Text(
                          data['timestamp'] != null
                              ? (data['timestamp'] as firestore.Timestamp).toDate().toString()
                              : '',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
