import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/wedding_models.dart';

class WeddingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  StreamSubscription? _milestoneSub;
  StreamSubscription? _expenseSub;
  StreamSubscription? _guestSub;

  double totalBudget = 0;
  DateTime? weddingDate;
  List<Expense> expenses = [];
  List<WeddingTask> tasks = [];
  List<WeddingGuest> guests = [];

  bool isLoading = true;

  String? get _uid => _auth.currentUser?.uid;

  DocumentReference<Map<String, dynamic>> get _milestoneDoc =>
      _firestore.collection('milestones').doc(_uid ?? 'unknown');

  WeddingProvider() {
    _initStreams();
  }

  void _initStreams() {
    final uid = _uid;
    if (uid == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    // 1. Dengar data daripada doc 'milestones' (Tarikh & Checklist Tasks)
    _milestoneSub = _milestoneDoc.snapshots().listen((doc) {
      if (doc.exists) {
        final data = doc.data() ?? {};
        totalBudget = (data['totalBudget'] as num?)?.toDouble() ?? 0;
        if (data['weddingDate'] != null) {
          weddingDate = (data['weddingDate'] as Timestamp).toDate();
        }
        if (data['tasks'] != null) {
          final list = data['tasks'] as List;
          tasks = list.map((t) => WeddingTask.fromMap(t)).toList();
        }
      }
      _checkLoadingDone();
    });

    // 2. Dengar data daripada collection 'expenses' (Asing dari Milestone)
    _expenseSub = _firestore
        .collection('expenses')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      expenses = snapshot.docs.map((doc) => Expense.fromDoc(doc)).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
      _checkLoadingDone();
    });

    // 3. Dengar data daripada collection 'guests' (Asing dari Milestone)
    _guestSub = _firestore
        .collection('guests')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .listen((snapshot) {
      guests = snapshot.docs.map((doc) => WeddingGuest.fromDoc(doc)).toList();
      _checkLoadingDone();
    });
  }

  void _checkLoadingDone() {
    isLoading = false;
    notifyListeners();
  }

  // ---------------- Derived values (Pengiraan Dinamik) ----------------

  double get totalSpent => expenses.fold<double>(0, (sum, e) => sum + e.amount);

  double get budgetRemaining => totalBudget - totalSpent;

  int? get daysUntilWedding {
    final date = weddingDate;
    if (date == null) return null;
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    final weddingMidnight = DateTime(date.year, date.month, date.day);
    return weddingMidnight.difference(todayMidnight).inDays;
  }

  // ---------------- Budget & Tarikh Perkahwinan ----------------

  Future<void> setTotalBudget(double amount) async {
    await _milestoneDoc.set({'totalBudget': amount}, SetOptions(merge: true));
  }

  Future<void> setWeddingDate(DateTime date) async {
    await _milestoneDoc.set(
      {'weddingDate': Timestamp.fromDate(date)},
      SetOptions(merge: true),
    );
  }

  // ---------------- Perbelanjaan (Expenses - Collection Berasingan) ----------------

  Future<void> addExpense({
    required String category,
    required String description,
    required double amount,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    final expense = Expense(
      id: '',
      category: category,
      description: description,
      amount: amount,
      date: DateTime.now(),
    );
    await _firestore.collection('expenses').add(expense.toMap(uid));
  }

  Future<void> removeExpense(String id) async {
    await _firestore.collection('expenses').doc(id).delete();
  }

  // ---------------- Tugasan (Checklist Tasks) ----------------

  Future<void> addTask({required String title, required DateTime dueDate}) async {
    final task = WeddingTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dueDate: dueDate,
    );
    final updated = [...tasks, task];
    await _milestoneDoc.set({'tasks': updated.map((t) => t.toMap()).toList()}, SetOptions(merge: true));
  }

  Future<void> toggleTask(String id) async {
    final updated = tasks
        .map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t)
        .toList();
    await _milestoneDoc.set({'tasks': updated.map((t) => t.toMap()).toList()}, SetOptions(merge: true));
  }

  Future<void> removeTask(String id) async {
    final updated = tasks.where((t) => t.id != id).toList();
    await _milestoneDoc.set({'tasks': updated.map((t) => t.toMap()).toList()}, SetOptions(merge: true));
  }

  // ---------------- Pengurusan Tetamu (Guests - Collection Berasingan) ----------------

  Future<void> addGuest(String name, String status) async {
    final uid = _uid;
    if (uid == null) return;

    final guest = WeddingGuest(id: '', name: name, status: status);
    await _firestore.collection('guests').add(guest.toMap(uid));
  }

  Future<void> removeGuest(String id) async {
    await _firestore.collection('guests').doc(id).delete();
  }

  @override
  void dispose() {
    _milestoneSub?.cancel();
    _expenseSub?.cancel();
    _guestSub?.cancel();
    super.dispose();
  }
}