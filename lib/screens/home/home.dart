import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lab3/models/exam.dart';
import 'package:lab3/screens/home/exam_list.dart';
import 'package:lab3/services/auth.dart';
import 'package:lab3/services/database.dart';
import 'package:provider/provider.dart';
import 'dart:core';
import 'package:timezone/timezone.dart' as tz;

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();

  Home({Key? key}) : super(key: key);

  Future<void> addExam(BuildContext context) async {
    String subject = '';
    DateTime timeSlot = DateTime.now();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add new exam"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      subject = value;
                    },
                    decoration: const InputDecoration(labelText: 'Subject'),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Text('Date: ${timeSlot.toLocal()}'),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: timeSlot,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                                const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              timeSlot = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                timeSlot.hour,
                                timeSlot.minute,
                              );
                            });
                          }
                        },
                        child: const Text('Pick Date'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Time: ${timeSlot
                          .toLocal()
                          .hour}:${timeSlot
                          .toLocal()
                          .minute}'),
                      const SizedBox(width: 8.0),
                      ElevatedButton(
                        onPressed: () async {
                          TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(timeSlot),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              timeSlot = DateTime(
                                timeSlot.year,
                                timeSlot.month,
                                timeSlot.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                            });
                          }
                        },
                        child: const Text('Pick Time'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      final user = Provider.of<User?>(context, listen: false);
                      await DatabaseService(user!.uid).addExam(
                          subject, timeSlot);
                      scheduleNotification(timeSlot, subject);
                      Navigator.pop(context);
                    },
                    child: const Text("Add"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamProvider<List<Exam>>.value(
      initialData: const [],
      value: DatabaseService(user!.uid).exams,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: const Text('Upcoming Exams'),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () {
                // Handle the addition of a new exam
                addExam(context);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: const ExamList(),
      ),
    );
  }

  void scheduleNotification(DateTime examDateTime, String subject) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'exam_channel_id',
      'Exam reminders',
      'Channel for exam reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduledDate =
    tz.TZDateTime.from(examDateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'Exam Reminder', // Notification title
      'Don\'t forget your $subject exam!',
      scheduledDate.subtract(const Duration(minutes: 15)),
      // 15 minutes before the exam
      const NotificationDetails(
        android: androidPlatformChannelSpecifics,
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
