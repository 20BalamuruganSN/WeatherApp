import 'package:cloud_firestore/cloud_firestore.dart';

class WeatherDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveWeatherData(String city, Map<String, dynamic> weatherData) async {
    await _firestore.collection('weatherData').add({
      'city': city,
      'temperature': weatherData['main']['temp'],
      'condition': weatherData['weather'][0]['description'],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getWeatherData() {
    return _firestore
        .collection('weatherData')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
