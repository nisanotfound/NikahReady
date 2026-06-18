import 'package:flutter/material.dart';
import '../models/mahr_model.dart';

class MahrProvider extends ChangeNotifier {
  MahrModel _mahr = MahrModel(
    currentSavings: 0,
    targetMahr: 0,
    timelineMonths: 0,
    monthlySavingsNeeded: 0,
  );

  MahrModel get mahr => _mahr;

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
      currentSavings: currentSavings,
      targetMahr: targetMahr,
      timelineMonths: timelineMonths,
      monthlySavingsNeeded: monthlySavingsNeeded,
    );

    notifyListeners();
  }
}