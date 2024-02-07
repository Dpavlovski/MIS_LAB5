import 'package:flutter/material.dart';
import 'package:lab3/models/exam.dart';
import 'package:provider/provider.dart';

class ExamList extends StatefulWidget {
  const ExamList({super.key});

  @override
  State<ExamList> createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {



  // void editClothing(Clothing clothing) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       String name = clothing.name;
  //       String color = clothing.color;
  //       String price = clothing.price.toString(); // Convert to String
  //
  //       return AlertDialog(
  //         title: const Text("Edit clothing"),
  //         content: Column(
  //           children: [
  //             TextField(
  //               onChanged: (value) {
  //                 name = value;
  //               },
  //               decoration: InputDecoration(labelText: 'Name'),
  //               controller: TextEditingController(text: clothing.name), // Set initial value
  //             ),
  //             TextField(
  //               onChanged: (value) {
  //                 color = value;
  //               },
  //               decoration: InputDecoration(labelText: 'Color'),
  //               controller: TextEditingController(text: clothing.color), // Set initial value
  //             ),
  //             TextField(
  //               onChanged: (value) {
  //                 price = value;
  //               },
  //               decoration: InputDecoration(labelText: 'Price'),
  //               controller: TextEditingController(text: clothing.price.toString()), // Set initial value
  //             ),
  //           ],
  //         ),
  //         actions: [
  //           ElevatedButton(
  //             onPressed: () {
  //               setState(() {
  //                 if (name.isNotEmpty && color.isNotEmpty && price.isNotEmpty) {
  //                   // Find the index of the clothing item in the list
  //                   int index = clothingList.indexOf(clothing);
  //
  //                   // Update the properties of the existing object
  //                   clothingList[index].name = name;
  //                   clothingList[index].color = color;
  //                   clothingList[index].price = int.parse(price);
  //                 }
  //                 Navigator.pop(context);
  //               });
  //             },
  //             child: const Text("Update"),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  //
  //
  // void deleteClothingConfirmation(int index) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Delete Clothing"),
  //         content: const Text("Are you sure you want to delete this item?",
  //             style: TextStyle(color: Colors.blue)),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //             child: const Text(
  //               "Cancel",
  //               style: TextStyle(color: Colors.black),
  //             ),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               setState(() {
  //                 clothingList.removeAt(index);
  //               });
  //               Navigator.pop(context);
  //             },
  //             child: const Text(
  //               "Delete",
  //               style: TextStyle(color: Colors.red),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    final exams = Provider.of<List<Exam>>(context);
    exams.forEach((exam) {
      print(exam.subject);
      print(exam.timeSlot);
    });
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Date: ${exams[index].timeSlot.day}/${exams[index].timeSlot.month}/${exams[index].timeSlot.year}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Time: ${exams[index].timeSlot.hour}:${exams[index].timeSlot.minute}',
                  style: TextStyle(
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
