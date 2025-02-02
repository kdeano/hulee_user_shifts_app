import 'package:flutter/material.dart';
import 'package:hulee_user_shifts_app/config/consts.dart';
import 'package:hulee_user_shifts_app/models/shift.dart';
import 'package:hulee_user_shifts_app/screens/shift_details_page.dart';
import 'package:hulee_user_shifts_app/services/shifts_api.dart';
import 'package:hulee_user_shifts_app/widgets/toast.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyCalendarView extends StatefulWidget {
  const MonthlyCalendarView({super.key});

  @override
  MonthlyCalendarViewState createState() => MonthlyCalendarViewState();
}

class MonthlyCalendarViewState extends State<MonthlyCalendarView> {
  List<Shift> _shifts = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _showClockInToast = false;
  bool _showClockOutToast = false;
  final Map<String, bool> _clockInStatus = {};
  final Map<String, bool> _clockOutStatus = {};
  late final ValueNotifier<List<Shift>> _selectedShifts;

  @override
  void initState() {
    super.initState();
    _loadShifts();
    _selectedDay = _focusedDay;
    _selectedShifts = ValueNotifier(_getShiftsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _selectedShifts.value = _getShiftsForDay(_selectedDay!);
      });
    }
  }

  void _onClockIn(Shift shift) {
    _clockInStatus[shift.id!] = true;
    Navigator.pop(context);
    setState(() {
      _showClockInToast = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showClockInToast = false;
      });
    });
  }

  void _onClockOut(Shift shift) {
    _clockOutStatus[shift.id!] = true;
    Navigator.pop(context);
    setState(() {
      _showClockOutToast = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showClockOutToast = false;
      });
    });
  }

  List<Shift> _getShiftsForDay(DateTime day) {
    return _shifts.where((shift) {
      if (shift.date == null) return false;

      DateTime shiftDate = DateTime.parse(shift.date!);
      return isSameDay(shiftDate, day);
    }).toList();
  }

  Future<void> _loadShifts() async {
    final shifts = await ShiftsApi.getShifts();
    setState(() {
      _shifts = shifts;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_shifts.isEmpty) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Monthly Calendar View'),
          ),
          body: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2025, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                calendarFormat: _calendarFormat,
                startingDayOfWeek: StartingDayOfWeek.monday,
                onDaySelected: _onDaySelected,
                eventLoader: _getShiftsForDay,
                calendarStyle: CalendarStyle(outsideDaysVisible: false),
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                onPageChanged: (focusedDay) => _focusedDay = focusedDay,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    List<Shift> shiftsForDay = _shifts.where((shift) {
                      if (shift.date == null) {
                        return false;
                      }

                      DateTime shiftDate = DateTime.parse(shift.date!);

                      return isSameDay(shiftDate, day);
                    }).toList();

                    if (shiftsForDay.isNotEmpty) {
                      String shiftId = shiftsForDay.first.id!;

                      bool isClockedIn = _clockInStatus[shiftId] ?? false;
                      bool isClockedOut = _clockOutStatus[shiftId] ?? false;

                      Color color = isClockedIn && !isClockedOut
                          ? Colors.orange
                          : isClockedOut
                              ? Colors.green
                              : Colors.blue;

                      return Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        width: 20,
                        height: 20,
                        child: Center(
                          child: Text(
                            shiftsForDay.length.toString(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _selectedShifts,
                  builder: (context, value, _) {
                    return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ShiftDetailsPage(
                                      shift: value[index],
                                      onClockIn: _onClockIn,
                                      onClockOut: _onClockOut,
                                      isClockedIn:
                                          _clockInStatus[value[index].id!] ??
                                              false,
                                      isClockedOut:
                                          _clockOutStatus[value[index].id!] ??
                                              false,
                                    ),
                                  ),
                                );
                              },
                              title: Text(
                                  '${value[index].title} - ${value[index].role} - ${value[index].location!.name} [${value[index].startTime} - ${value[index].finishTime}]'),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
        _showClockInToast
            ? Toast(message: "Clock in successful", type: ToastType.info)
            : Container(),
        _showClockOutToast
            ? Toast(message: "Clock out successful", type: ToastType.success)
            : Container(),
      ],
    );
  }
}
