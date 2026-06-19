import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mahr_model.dart';

class MahrProvider extends ChangeNotifier {
  MahrModel _mahr = MahrModel(
    currentSavings: 0,
    targetMahr: 0,
    timelineMonths: 0,
    monthlySavingsNeeded: 0,
  );

  bool _isSaving = false;
  bool _isLoading = false;

  MahrModel get mahr => _mahr;
  bool get isSaving => _isSaving;
  bool get isLoading => _isLoading;

  void calculateMahr({
    required double currentSavings,
    required double targetMahr,
    required int timelineMonths,
  }) {
    double monthlySavingsNeeded = 0;

    if (timelineMonths > 0 && targetMahr > currentSavings) {
      monthlySavingsNeeded = (targetMahr - currentSavings) / timelineMonths;
    }

    _mahr = MahrModel(
      id: _mahr.id,
      currentSavings: currentSavings,
      targetMahr: targetMahr,
      timelineMonths: timelineMonths,
      monthlySavingsNeeded: monthlySavingsNeeded,
      updatedAt: _mahr.updatedAt,
    );

    notifyListeners();
  }

  Future<void> saveOrUpdateMahrGoal() async {
    _isSaving = true;
    notifyListeners();

    try {
      if (_mahr.id == null) {
        final docRef = await FirebaseFirestore.instance
            .collection('mahr_goals')
            .add(_mahr.toMap());

        _mahr = MahrModel(
          id: docRef.id,
          currentSavings: _mahr.currentSavings,
          targetMahr: _mahr.targetMahr,
          timelineMonths: _mahr.timelineMonths,
          monthlySavingsNeeded: _mahr.monthlySavingsNeeded,
        );
      } else {
        await FirebaseFirestore.instance
            .collection('mahr_goals')
            .doc(_mahr.id)
            .update(_mahr.toMap());
      }
    } catch (e) {
      debugPrint('MahrProvider: Failed to save/update mahr goal — $e');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> loadLatestMahrGoal() async {
    _isLoading = true;
    notifyListeners();

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('mahr_goals')
          .orderBy('updatedAt', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        _mahr = MahrModel.fromFirestore(querySnapshot.docs.first);
      }
    } catch (e) {
      debugPrint('MahrProvider: Failed to load mahr goal — $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetMahr() {
    _mahr = MahrModel(
      currentSavings: 0,
      targetMahr: 0,
      timelineMonths: 0,
      monthlySavingsNeeded: 0,
    );
    notifyListeners();
  }
}