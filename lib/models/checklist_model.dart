import 'package:cloud_firestore/cloud_firestore.dart';

class ChecklistTask {
  final String id;
  final String title;
  final String category;
  final bool isCompleted;
  final DateTime createdAt;

  ChecklistTask({
    required this.id,
    required this.title,
    required this.category,
    required this.isCompleted,
    required this.createdAt,
  });

  factory ChecklistTask.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChecklistTask(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'Spiritual',
      isCompleted: data['isCompleted'] ?? false,
      // ✅ Handle kalau field takde (backward compatible)
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}