import 'package:cloud_firestore/cloud_firestore.dart';

// =========================================================================
// GLOBAL EXPENSE CATEGORIES
// =========================================================================
const List<String> expenseCategories = [
  'Venue',
  'Catering',
  'Decoration',
  'Attire',
  'Make Up',
  'Photographer',
  'Invitations & Door Gifts',
  'Dowry & Hantaran',
  'Course & Marriage Documents',
  'Miscellaneous',
];

// ==========================================
// 1. EXPENSE MODEL (Isolated Collection)
// ==========================================
class Expense {
  final String id;
  final String category;
  final String description;
  final double amount;
  final DateTime date;

  Expense({
    required this.id,
    required this.category,
    required this.description,
    required this.amount,
    required this.date,
  });

  /// Converts the object to a Map for a standalone Firestore document
  Map<String, dynamic> toMap(String uid) => {
        'uid': uid,
        'category': category,
        'description': description,
        'amount': amount,
        'date': Timestamp.fromDate(date),
      };

  /// Factory constructor to build an Expense object from a Firestore document snapshot
  factory Expense.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return Expense(
      id: doc.id,
      category: data['category'] ?? 'Miscellaneous',
      description: data['description'] ?? '',
      amount: (data['amount'] as num?)?.toDouble() ?? 0,
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

// ==========================================
// 2. WEDDING TASK MODEL (Checklist)
// ==========================================
class WeddingTask {
  final String id;
  final String title;
  final DateTime dueDate;
  final bool isCompleted;

  WeddingTask({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  /// Allows updating the 'isCompleted' status smoothly without mutating original data
  WeddingTask copyWith({bool? isCompleted}) => WeddingTask(
        id: id,
        title: title,
        dueDate: dueDate,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'dueDate': Timestamp.fromDate(dueDate),
        'isCompleted': isCompleted,
      };

  factory WeddingTask.fromMap(Map<String, dynamic> map) => WeddingTask(
        id: map['id'] as String,
        title: map['title'] ?? '',
        dueDate: (map['dueDate'] as Timestamp).toDate(),
        isCompleted: map['isCompleted'] ?? false,
      );
}

// ==========================================
// 3. WEDDING GUEST MODEL (Isolated Collection)
// ==========================================
class WeddingGuest {
  final String id;
  final String name;
  final String status; // 'Confirmed', 'Pending', 'Declined'

  WeddingGuest({
    required this.id,
    required this.name,
    required this.status,
  });

  /// Converts the guest item to a Map bundled with user UID for security queries
  Map<String, dynamic> toMap(String uid) => {
        'uid': uid,
        'name': name,
        'status': status,
      };

  /// Generates a WeddingGuest object directly from a DocumentSnapshot
  factory WeddingGuest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return WeddingGuest(
      id: doc.id,
      name: data['name'] ?? '',
      status: data['status'] ?? 'Pending',
    );
  }
}