import 'package:flutter/material.dart';
import 'package:hulee_user_shifts_app/models/shift.dart';
import 'package:hulee_user_shifts_app/screens/shift_details_page.dart';
import 'package:hulee_user_shifts_app/services/shifts_api.dart';
import 'package:table_calendar/table_calendar.dart';

class MonthlyCalendarView extends StatefulWidget {
  @override
  _MonthlyCalendarViewState createState() => _MonthlyCalendarViewState();
}

class _MonthlyCalendarViewState extends State<MonthlyCalendarView> {
  List<Shift> _shifts = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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

    return Scaffold(
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
                  return Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.blue,
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
                        margin:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(),
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ShiftDetailsPage(shift: value[index]),
                              ),
                            );
                          },
                          title:
                              Text('${value[index].id} ${value[index].title}'),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
