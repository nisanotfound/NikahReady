// lib/providers/quiz_provider.dart

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quiz_model.dart';

enum QuizPhase { idle, inProgress, feedback, completed }

class QuizProvider extends ChangeNotifier {
  // ── State ──────────────────────────────────────────────────────────────────
  QuizTopic? _currentTopic;
  int _currentIndex = 0;
  int? _selectedOptionIndex;
  int _correctCount = 0;
  QuizPhase _phase = QuizPhase.idle;
  bool _isSaving = false;

  // ── Getters ────────────────────────────────────────────────────────────────
  QuizTopic? get currentTopic => _currentTopic;
  QuizPhase get phase => _phase;
  int? get selectedOptionIndex => _selectedOptionIndex;
  int get correctCount => _correctCount;
  bool get isSaving => _isSaving;

  QuizQuestion? get currentQuestion {
    if (_currentTopic == null) return null;
    if (_currentIndex >= _currentTopic!.questions.length) return null;
    return _currentTopic!.questions[_currentIndex];
  }

  int get currentIndex => _currentIndex;
  int get totalQuestions => _currentTopic?.questions.length ?? 0;

  bool get isCorrect =>
      _selectedOptionIndex != null &&
      _selectedOptionIndex == currentQuestion?.correctIndex;

  double get progress =>
      totalQuestions == 0 ? 0 : (_currentIndex + 1) / totalQuestions;

  QuizResult? get result {
    if (_currentTopic == null) return null;
    return QuizResult(
      topicId: _currentTopic!.id,
      totalQuestions: totalQuestions,
      correctAnswers: _correctCount,
      completedAt: DateTime.now(),
    );
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void startQuiz(QuizTopic topic) {
    _currentTopic = topic;
    _currentIndex = 0;
    _selectedOptionIndex = null;
    _correctCount = 0;
    _phase = QuizPhase.inProgress;
    notifyListeners();
  }

  void selectAnswer(int optionIndex) {
    if (_phase != QuizPhase.inProgress) return;
    _selectedOptionIndex = optionIndex;
    if (optionIndex == currentQuestion?.correctIndex) {
      _correctCount++;
    }
    _phase = QuizPhase.feedback;
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentTopic == null) return;

    final nextIndex = _currentIndex + 1;

    if (nextIndex >= _currentTopic!.questions.length) {
      _phase = QuizPhase.completed;
      _saveResultToFirestore();
    } else {
      _currentIndex = nextIndex;
      _selectedOptionIndex = null;
      _phase = QuizPhase.inProgress;
    }
    notifyListeners();
  }

  void retryQuiz() {
    if (_currentTopic != null) startQuiz(_currentTopic!);
  }

  void resetToTopicSelect() {
    _currentTopic = null;
    _currentIndex = 0;
    _selectedOptionIndex = null;
    _correctCount = 0;
    _phase = QuizPhase.idle;
    notifyListeners();
  }

  // ── Firebase ───────────────────────────────────────────────────────────────

  Future<void> _saveResultToFirestore() async {
    if (_currentTopic == null) return;
    _isSaving = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('quiz_results').add({
        'topicId': _currentTopic!.id,
        'topicTitle': _currentTopic!.title,
        'totalQuestions': totalQuestions,
        'correctAnswers': _correctCount,
        'score': result?.score,
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('QuizProvider: Failed to save result — $e');
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}