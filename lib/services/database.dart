import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab3/models/exam.dart';

class DatabaseService {
  final String uid;
  DatabaseService(this.uid);

  final CollectionReference examCollection =
  FirebaseFirestore.instance.collection('exams');

  Future<void> addExam(String subject, DateTime timeSlot) async {
    await examCollection.add({
      'uid': uid,
      'subject': subject,
      'timeSlot': timeSlot,
    });
  }

  Future<void> updateExam(String examId, String subject, DateTime timeSlot) async {
    await examCollection.doc(examId).update({
      'subject': subject,
      'timeSlot': timeSlot,
    });
  }

  Future<void> deleteExam(String examId) async {
    await examCollection.doc(examId).delete();
  }

  List<Exam> _examListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Exam(
        subject: data['subject'] ?? '',
        timeSlot: (data['timeSlot'] as Timestamp).toDate(),
      );
    }).toList();
  }

  Stream<List<Exam>> get exams {
    return examCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_examListFromSnapshot);
  }
}
