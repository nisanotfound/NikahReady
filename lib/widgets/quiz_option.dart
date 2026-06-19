// lib/widgets/quiz_option.dart

import 'package:flutter/material.dart';

const _kPrimary      = Color(0xFF9B7EBD);
const _kPrimaryLight = Color(0xFFEDE7F6);

enum OptionState { idle, correct, wrong, dimmed }

class QuizOption extends StatelessWidget {
  final String text;
  final String label; // A / B / C / D
  final OptionState state;
  final VoidCallback? onTap;

  const QuizOption({
    super.key,
    required this.text,
    required this.label,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color bgColor;
    Color borderColor;
    Color textColor;
    Color labelBg;
    IconData? trailingIcon;

    switch (state) {
      case OptionState.correct:
        bgColor     = const Color(0xFFE8F5E9);
        borderColor = const Color(0xFF2E7D32);
        textColor   = const Color(0xFF1B5E20);
        labelBg     = const Color(0xFF2E7D32);
        trailingIcon = Icons.check_circle_rounded;
        break;
      case OptionState.wrong:
        bgColor     = const Color(0xFFFFEBEE);
        borderColor = const Color(0xFFC62828);
        textColor   = const Color(0xFFB71C1C);
        labelBg     = const Color(0xFFC62828);
        trailingIcon = Icons.cancel_rounded;
        break;
      case OptionState.dimmed:
        bgColor     = _kPrimaryLight.withValues(alpha: 0.4);
        borderColor = const Color(0xFFD8CCE8);
        textColor   = colorScheme.onSurface.withValues(alpha: 0.38);
        labelBg     = const Color(0xFFD8CCE8);
        trailingIcon = null;
        break;
      case OptionState.idle:
      bgColor     = Colors.white;
        borderColor = const Color(0xFFD8CCE8);
        textColor   = const Color(0xFF2C1B4D);
        labelBg     = _kPrimary;
        trailingIcon = null;
    }

    return GestureDetector(
      onTap: state == OptionState.idle ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.6),
          boxShadow: state == OptionState.idle
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Label badge (A/B/C/D)
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: labelBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  height: 1.4,
                ),
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: 8),
              Icon(trailingIcon, color: borderColor, size: 22),
            ],
          ],
        ),
      ),
    );
  }
}