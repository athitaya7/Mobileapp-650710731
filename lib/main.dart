import 'package:flutter/material.dart';
import 'package:pm25_app/aqi_example/aqi_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AQI Monitor',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green,
      ),
      home: const AqiExample(),       // เรียกใช้ AqiExample
      debugShowCheckedModeBanner: false,
    );
  }
}