import 'package:flutter/material.dart';
import 'package:lab3/models/exam.dart';
import 'package:provider/provider.dart';

class ExamList extends StatefulWidget {
  const ExamList({super.key});

  @override
  State<ExamList> createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {

  @override
  Widget build(BuildContext context) {
    final exams = Provider.of<List<Exam>>(context);

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Adjust the number of columns as needed
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: exams.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 2.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exams[index].subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: ${exams[index].timeSlot.day}/${exams[index].timeSlot.month}/${exams[index].timeSlot.year}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Time: ${exams[index].timeSlot.hour}:${exams[index].timeSlot.minute}',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
