import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lab3/models/exam.dart';
import 'package:lab3/screens/home/exam_list.dart';
import 'package:lab3/services/auth.dart';
import 'package:lab3/services/database.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();


  void addExam(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String subject = '';
        DateTime timeSlot = DateTime.now();

        return AlertDialog(
          title: const Text("Add new exam"),
          content: Column(
            children: [
              TextField(
                onChanged: (value) {
                  subject = value;
                },
                decoration: InputDecoration(labelText: 'Subject'),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Text('Date: ${timeSlot.toLocal()}'),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: timeSlot,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                          timeSlot = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            timeSlot.hour,
                            timeSlot.minute,
                          );
                      }
                    },
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Time: ${timeSlot.toLocal().hour}:${timeSlot.toLocal().minute}'),
                  SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(timeSlot),
                      );
                      if (pickedTime != null) {
                          timeSlot = DateTime(
                            timeSlot.year,
                            timeSlot.month,
                            timeSlot.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                      }
                    },
                    child: Text('Pick Time'),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  final user = Provider.of<User?>(context, listen: false);
                  await DatabaseService(user!.uid).updateUserData(subject, timeSlot);
                  Navigator.pop(context);
                },
                child: const Text("Add"),
              ),
            ],
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return StreamProvider<List<Exam>>.value(
      initialData: [],
      value: DatabaseService(user!.uid).exams,
      child: Scaffold(
        backgroundColor: Colors.blue[50],
        appBar: AppBar(
          title: Text('Upcoming Exams'),
          backgroundColor: Colors.blue[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text('Add'),
              onPressed: () {
                // Handle the addition of a new exam
                addExam(context);
              },
            ),
            TextButton.icon(
              icon: Icon(Icons.person),
              label: Text('Logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: ExamList()
      ),
    );

  }

// Function to update an existing exam
  void _updateExam(BuildContext context, String examId, String subject, DateTime dateTime) async {
    // Example usage of updateExam
    final user = Provider.of<User?>(context);
    await DatabaseService(user!.uid).updateExam(examId, subject, dateTime);
  }

// Function to delete an exam
  void _deleteExam(BuildContext context, String examId) async {
    // Example usage of deleteExam
    final user = Provider.of<User?>(context);
    await DatabaseService(user!.uid).deleteExam(examId);
  }



}


