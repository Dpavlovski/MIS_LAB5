import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lab3/models/exam.dart';
import 'package:lab3/models/user_data.dart';

class DatabaseService {

  final String uid;
  DatabaseService(this.uid);

  final CollectionReference examCollection = FirebaseFirestore.instance.collection('exams');

  Future<void> updateUserData(String subject, Timestamp timeSlot) async {
    return await examCollection.doc(uid).set({
      'subject': subject,
      'timeSlot': timeSlot.toDate(), // Convert Timestamp to DateTime
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
    try {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        return Exam(
          subject: data['subject'] ?? '',
          timeSlot: (data['timeSlot'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch(e) {
      print(e.toString());
      return List.empty();
    }
  }

  Stream<List<Exam>>? get exams {
    return examCollection
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map(_examListFromSnapshot);
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      subject: (snapshot.data() as Map<String, dynamic>)['subject'] as String,
      timeSlot: ((snapshot.data() as Map<String, dynamic>)['timeSlot'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Stream<UserData> get userData {
    return examCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
  }
}