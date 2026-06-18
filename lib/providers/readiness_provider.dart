import 'package:flutter/material.dart';

class ReadinessProvider extends ChangeNotifier {
  // Pengiraan Spiritual (Kuiz)
  int calculateSpiritual(int totalQuestions, int correctAnswers) {
    if (totalQuestions == 0) return 0; 
    return ((correctAnswers / totalQuestions) * 100).round();
  }

  // Pengiraan Financial (Mahr)
  int calculateFinancial(double currentSavings, double targetMahr) {
    if (targetMahr == 0) return 0; 
    int percentage = ((currentSavings / targetMahr) * 100).round();
    return percentage > 100 ? 100 : percentage; 
  }

  // Pengiraan Personal (Checklist)
  int calculatePersonal(int totalTasks, int completedTasks) {
    if (totalTasks == 0) return 71; 
    return ((completedTasks / totalTasks) * 100).round();
  }

  // Pengiraan Keseluruhan
  int calculateOverall(int spiritual, int financial, int personal) {
    return ((spiritual + financial + personal) / 3).round();
  }
}