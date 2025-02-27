import 'package:flutter/material.dart';
import 'package:hulee_user_shifts_app/screens/home_screen.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hulee Shifts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(title: 'Hulee Shifts'),
    );
  }
}
