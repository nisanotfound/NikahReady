import 'package:cloud_firestore/cloud_firestore.dart';

class MahrModel {
  final String? id;
  final double currentSavings;
  final double targetMahr;
  final int timelineMonths;
  final double monthlySavingsNeeded;
  final DateTime? updatedAt;

  MahrModel({
    this.id,
    required this.currentSavings,
    required this.targetMahr,
    required this.timelineMonths,
    required this.monthlySavingsNeeded,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'currentSavings': currentSavings,
      'targetMahr': targetMahr,
      'timelineMonths': timelineMonths,
      'monthlySavingsNeeded': monthlySavingsNeeded,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory MahrModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MahrModel(
      id: doc.id,
      currentSavings: (data['currentSavings'] ?? 0).toDouble(),
      targetMahr: (data['targetMahr'] ?? 0).toDouble(),
      timelineMonths: data['timelineMonths'] ?? 0,
      monthlySavingsNeeded: (data['monthlySavingsNeeded'] ?? 0).toDouble(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}