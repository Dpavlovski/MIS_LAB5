import 'package:flutter/material.dart';
import 'package:lab3/models/exam.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ExamList extends StatefulWidget {
  const ExamList({Key? key}) : super(key: key);

  @override
  State<ExamList> createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  late List<Exam> _exams;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _firstDay = DateTime.now().subtract(Duration(days: 365)); // Assuming you want to show exams for the past year
    _lastDay = DateTime.now().add(Duration(days: 365)); // Assuming you want to show exams for the next year
  }

  @override
  Widget build(BuildContext context) {
    _exams = Provider.of<List<Exam>>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: _firstDay,
          lastDay: _lastDay,
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
          ),
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(color: Colors.black),
            weekendStyle: TextStyle(color: Colors.red),
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_focusedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _focusedDay = selectedDay;
            });
          },
        ),
        SizedBox(height: 20),
        Text(
          'Exams for ${_focusedDay.day}/${_focusedDay.month}/${_focusedDay.year}:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: _exams.length,
            itemBuilder: (context, index) {
              final exam = _exams[index];
              if (isSameDay(exam.timeSlot, _focusedDay)) {
                return Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exam.subject,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Time: ${exam.timeSlot.hour}:${exam.timeSlot.minute}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  bool isSameDay(DateTime day1, DateTime day2) {
    return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
  }
}
