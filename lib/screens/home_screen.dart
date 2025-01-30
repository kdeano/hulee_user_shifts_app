import 'package:flutter/material.dart';
import 'package:hulee_user_shifts_app/screens/monthly_calendar_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: MonthlyCalendarView(),
    );
  }
}
