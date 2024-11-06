import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'WeatherHome.dart';
import 'firebase_options.dart';
import 'WeatherService.dart';
import 'WeatherDatabase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase with platform-specific options
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

