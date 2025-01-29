import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigo,
        titleTextStyle: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
