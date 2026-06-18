import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/checklist_model.dart';

class ChecklistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userId;

  ChecklistService({required this.userId});

  CollectionReference get _collection =>
      _db.collection('users').doc(userId).collection('checklist');

  Stream<List<ChecklistTask>> getTasks() {
    return _collection
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChecklistTask.fromDocument(doc))
            .toList());
  }

  Future<void> addTask(String title, String category) async {
    await _collection.add({
      'title': title,
      'category': category,
      'isCompleted': false,
      'createdAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> toggleTaskStatus(String taskId, bool currentStatus) async {
    await _collection.doc(taskId).update({
      'isCompleted': !currentStatus,
    });
  }

  Future<void> editTask(String taskId, String newTitle) async {
    await _collection.doc(taskId).update({
      'title': newTitle,
    });
  }

  Future<void> deleteTask(String taskId) async {
    await _collection.doc(taskId).delete();
  }

  Future<void> seedDefaultTasksIfEmpty() async {
    final snapshot = await _collection.limit(1).get();
    if (snapshot.docs.isNotEmpty) return;

    final defaults = [
      {'title': 'Perform 5 daily prayers consistently',      'category': 'Spiritual'},
      {'title': 'Complete one full recitation of Al-Quran',  'category': 'Spiritual'},
      {'title': 'Attend a premarital course',                'category': 'Spiritual'},
      {'title': 'Read a book on marriage fiqh',              'category': 'Spiritual'},
      {'title': 'Set a target mahr amount',                  'category': 'Financial'},
      {'title': 'Open a dedicated wedding savings account',  'category': 'Financial'},
      {'title': 'Prepare a wedding ceremony budget',         'category': 'Financial'},
      {'title': 'Clear critical debts',                      'category': 'Financial'},
      {'title': 'Discuss plans with family',                 'category': 'Personal'},
      {'title': 'Identify qualities in an ideal spouse',     'category': 'Personal'},
      {'title': 'Learn basic cooking skills',                'category': 'Personal'},
      {'title': 'Maintain physical and mental health',       'category': 'Personal'},
    ];

    final batch = _db.batch();
    for (int i = 0; i < defaults.length; i++) {
      final ref = _collection.doc();
      batch.set(ref, {
        'title': defaults[i]['title'],
        'category': defaults[i]['category'],
        'isCompleted': false,
        'createdAt': Timestamp.fromDate(
          DateTime.now().add(Duration(seconds: i)),
        ),
      });
    }
    await batch.commit();
  }

  Future<void> saveReadinessScore(double score) async {
    await _db.collection('users').doc(userId).set({
      'readinessScore': score,
      'scoreUpdatedAt': Timestamp.fromDate(DateTime.now()),
    }, SetOptions(merge: true));
  }
}