import 'package:flutter/material.dart';
import 'screens/main_page.dart'; // replace with the actual path to your main_page.dart file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainPage(),
    );
  }
}
