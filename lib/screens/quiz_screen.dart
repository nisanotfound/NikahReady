// lib/screens/quiz_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../providers/quiz_provider.dart';
import '../widgets/quiz_option.dart';

// ── Theme constants (matches main.dart seedColor: 0xFF9B7EBD) ─────────────────
const _kPrimary       = Color(0xFF9B7EBD); // main purple
const _kPrimaryDark   = Color(0xFF6A4C93); // deeper purple for gradients
const _kPrimaryLight  = Color(0xFFEDE7F6); // soft lavender tint
const _kOnPrimary     = Colors.white;
const _kTextDark      = Color(0xFF2C1B4D); // appBarTheme foregroundColor
const _kTextMid       = Color(0xFF6B5A7E); // muted purple-grey
const _kBorder        = Color(0xFFD8CCE8); // light purple border
const _kScaffold      = Color(0xFFFDFBFD); // matches scaffoldBackgroundColor
const _kCard          = Colors.white;

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: const _QuizScreenBody(),
    );
  }
}

class _QuizScreenBody extends StatelessWidget {
  const _QuizScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();

    return Scaffold(
      backgroundColor: _kScaffold,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: _kTextDark,
          onPressed: () {
            if (provider.phase == QuizPhase.idle) {
              Navigator.pop(context);
            } else {
              _confirmExit(context, provider);
            }
          },
        ),
        title: const Text(
          'Kuiz Fiqh Nikah',
          style: TextStyle(
            color: _kTextDark,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
        centerTitle: true,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: switch (provider.phase) {
          QuizPhase.idle      => _TopicSelectView(key: const ValueKey('topic')),
          QuizPhase.inProgress ||
          QuizPhase.feedback  => _QuestionView(key: const ValueKey('question')),
          QuizPhase.completed => _ResultView(key: const ValueKey('result')),
        },
      ),
    );
  }

  Future<void> _confirmExit(BuildContext context, QuizProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar Kuiz?'),
        content: const Text('Kemajuan anda dalam kuiz ini tidak akan disimpan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Teruskan', style: TextStyle(color: _kPrimary)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: _kPrimary),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed == true) provider.resetToTopicSelect();
  }
}

// ─── Topic Select ─────────────────────────────────────────────────────────────

class _TopicSelectView extends StatelessWidget {
  const _TopicSelectView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<QuizProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_kPrimaryDark, _kPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📚', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 10),
                const Text(
                  'Uji Pengetahuan\nFiqh Anda',
                  style: TextStyle(
                    color: _kOnPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pilih topik di bawah untuk memulakan kuiz.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Pilih Topik',
            style: TextStyle(
              color: _kTextDark,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          ...quizTopics.map((topic) => _TopicCard(
                topic: topic,
                onTap: () => provider.startQuiz(topic),
              )),
        ],
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final QuizTopic topic;
  final VoidCallback onTap;

  const _TopicCard({required this.topic, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _kPrimaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(topic.icon, style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topic.title,
                    style: const TextStyle(
                      color: _kTextDark,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    topic.subtitle,
                    style: const TextStyle(color: _kTextMid, fontSize: 12.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${topic.questions.length} soalan',
                    style: const TextStyle(
                      color: _kPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: _kPrimary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Question View ────────────────────────────────────────────────────────────

class _QuestionView extends StatelessWidget {
  const _QuestionView({super.key});

  static const _labels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final question = provider.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final inFeedback = provider.phase == QuizPhase.feedback;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar + counter
          Row(
            children: [
              Text(
                'Soalan ${provider.currentIndex + 1} / ${provider.totalQuestions}',
                style: const TextStyle(
                  color: _kTextMid,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: provider.progress,
                    minHeight: 7,
                    backgroundColor: _kPrimaryLight,
                    valueColor: const AlwaysStoppedAnimation(_kPrimary),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Question card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _kCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: _kBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              question.question,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _kTextDark,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Options
          ...question.options.asMap().entries.map((entry) {
            final idx  = entry.key;
            final text = entry.value;

            OptionState state;
            if (!inFeedback) {
              state = OptionState.idle;
            } else if (idx == question.correctIndex) {
              state = OptionState.correct;
            } else if (idx == provider.selectedOptionIndex) {
              state = OptionState.wrong;
            } else {
              state = OptionState.dimmed;
            }

            return QuizOption(
              label: _labels[idx],
              text: text,
              state: state,
              onTap: () => provider.selectAnswer(idx),
            );
          }),

          // Feedback panel
          if (inFeedback) ...[
            const SizedBox(height: 8),
            _FeedbackPanel(
              isCorrect: provider.isCorrect,
              explanation: question.explanation,
              isLastQuestion:
                  provider.currentIndex == provider.totalQuestions - 1,
              onNext: provider.nextQuestion,
            ),
          ],
        ],
      ),
    );
  }
}

class _FeedbackPanel extends StatelessWidget {
  final bool isCorrect;
  final String explanation;
  final bool isLastQuestion;
  final VoidCallback onNext;

  const _FeedbackPanel({
    required this.isCorrect,
    required this.explanation,
    required this.isLastQuestion,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor     = isCorrect ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    final borderColor = isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828);
    final iconColor   = isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.info_rounded,
                color: iconColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Betul! Tahniah 🎉' : 'Jawapan Tidak Tepat',
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            explanation,
            style: TextStyle(
              color: borderColor.withValues(alpha: 0.85),
              fontSize: 13.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: _kPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: onNext,
              child: Text(
                isLastQuestion ? 'Lihat Keputusan' : 'Soalan Seterusnya →',
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Result View ──────────────────────────────────────────────────────────────

class _ResultView extends StatelessWidget {
  const _ResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final result   = provider.result;
    if (result == null) return const SizedBox.shrink();

    final percentage  = result.score;
    final isExcellent = percentage >= 70;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      child: Column(
        children: [
          // Score card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isExcellent
                    ? [const Color(0xFF2E7D32), const Color(0xFF43A047)]
                    : [_kPrimaryDark, _kPrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Text(
                  isExcellent ? '🎉' : '📖',
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 12),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  result.grade,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${result.correctAnswers} / ${result.totalQuestions} jawapan betul',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 13.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stat row
          Row(
            children: [
              _StatChip(
                icon: Icons.check_circle_rounded,
                label: 'Betul',
                value: '${result.correctAnswers}',
                color: const Color(0xFF2E7D32),
              ),
              const SizedBox(width: 10),
              _StatChip(
                icon: Icons.cancel_rounded,
                label: 'Salah',
                value: '${result.totalQuestions - result.correctAnswers}',
                color: const Color(0xFFC62828),
              ),
              const SizedBox(width: 10),
              _StatChip(
                icon: Icons.quiz_rounded,
                label: 'Soalan',
                value: '${result.totalQuestions}',
                color: _kPrimary,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Saving indicator
          if (provider.isSaving)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _kPrimary,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Menyimpan keputusan...',
                    style: TextStyle(color: _kTextMid, fontSize: 13),
                  ),
                ],
              ),
            ),

          // Retry
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: _kPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text(
                'Cuba Semula',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              onPressed: provider.retryQuiz,
            ),
          ),
          const SizedBox(height: 12),

          // Back to topics
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: _kPrimary,
                side: const BorderSide(color: _kPrimary, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.grid_view_rounded),
              label: const Text(
                'Pilih Topik Lain',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
              onPressed: provider.resetToTopicSelect,
            ),
          ),
          const SizedBox(height: 12),

          // Home
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: _kTextMid,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              icon: const Icon(Icons.home_rounded),
              label: const Text(
                'Kembali ke Utama',
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _kCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kBorder),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: _kTextMid, fontSize: 11.5),
            ),
          ],
        ),
      ),
    );
  }
}