import 'package:flutter/material.dart';
import 'package:hulee_user_shifts_app/models/shift.dart';

class ShiftDetailsPage extends StatefulWidget {
  final Shift shift;
  final Function(Shift) onClockIn;
  final Function(Shift) onClockOut;

  const ShiftDetailsPage(
      {super.key,
      required this.shift,
      required this.onClockIn,
      required this.onClockOut});

  @override
  ShiftDetailsPageState createState() => ShiftDetailsPageState();
}

class ShiftDetailsPageState extends State<ShiftDetailsPage> {
  bool _isClockInEnabled = false;
  bool _isClockOutEnabled = false;
  String _clockInValidationMessage = '';
  String _clockOutValidationMessage = '';

  @override
  void initState() {
    super.initState();
    _checkClockInStatus();
    _checkClockOutStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shift Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 60),
            Text('Start Time: ${widget.shift.startTime}'),
            Text('End Time: ${widget.shift.finishTime}'),
            Text('Location: ${widget.shift.location!.name}'),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isClockInEnabled
                  ? () => widget.onClockIn(widget.shift)
                  : null,
              child: Text('Clock In'),
            ),
            Text(_clockInValidationMessage),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isClockOutEnabled
                  ? () => widget.onClockOut(widget.shift)
                  : null,
              child: Text('Clock Out'),
            ),
            Text(_clockOutValidationMessage),
          ],
        ),
      ),
    );
  }

  void _checkClockInStatus() {
    final currentTime = DateTime.now();
    final startTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(widget.shift.startTime!.split(':')[0]),
        int.parse(widget.shift.startTime!.split(':')[1]));
    final fifteenMinutesBeforeStart = startTime.subtract(Duration(minutes: 15));
    if (currentTime.isAfter(fifteenMinutesBeforeStart) &&
        currentTime.isBefore(startTime)) {
      setState(() {
        _isClockInEnabled = true;
      });
    } else {
      setState(() {
        _isClockInEnabled = false;
        _clockInValidationMessage =
            'You can only clock in 15 minutes before the shift starts.';
      });
    }
  }

  void _checkClockOutStatus() {
    final currentTime = DateTime.now();
    final endTime = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
        int.parse(widget.shift.finishTime!.split(':')[0]),
        int.parse(widget.shift.finishTime!.split(':')[1]));
    final fifteenMinutesAfterEnd = endTime.add(Duration(minutes: 15));
    if (currentTime.isAfter(endTime) &&
        currentTime.isBefore(fifteenMinutesAfterEnd)) {
      setState(() {
        _isClockOutEnabled = true;
      });
    } else {
      setState(() {
        _isClockOutEnabled = false;
        _clockOutValidationMessage =
            'You can only clock out 15 minutes after the shift ends.';
      });
    }
  }
}
