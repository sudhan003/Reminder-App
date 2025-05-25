import 'package:cloud_firestore/cloud_firestore.dart';

class UserTask {
  final String id;
  final String title;
  final String task;
  final String time;
  final String date;

  UserTask({
    required this.id,
    required this.title,
    required this.task,
    required this.time,
    required this.date,
  });

  factory UserTask.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserTask(
      id: doc.id,
      title: data['title'] ?? '',
      task: data['task'] ?? '',
      time: data['time'] ?? '',
      date: data['date'] ?? '',
    );
  }
}
