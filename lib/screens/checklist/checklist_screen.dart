import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../models/checklist_model.dart';
import '../../services/checklist_service.dart';

class ChecklistScreen extends StatefulWidget {
  const ChecklistScreen({super.key});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late final ChecklistService _checklistService;
  bool _seeded = false;
  double _lastSavedScore = -1;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _checklistService = ChecklistService(userId: user!.uid);
    _checklistService.seedDefaultTasksIfEmpty().then((_) {
      if (mounted) setState(() => _seeded = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: StreamBuilder<List<ChecklistTask>>(
        stream: _checklistService.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !_seeded) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF9B7EBD)),
            );
          }

          final tasks = snapshot.data ?? [];
          final spiritual = tasks.where((t) => t.category == "Spiritual").toList();
          final financial = tasks.where((t) => t.category == "Financial").toList();
          final personal  = tasks.where((t) => t.category == "Personal").toList();

          double pct(List<ChecklistTask> list) {
            if (list.isEmpty) return 0;
            return list.where((t) => t.isCompleted).length / list.length;
          }

          final double overallPct = tasks.isEmpty
              ? 0
              : tasks.where((t) => t.isCompleted).length / tasks.length;

          // ✅ Save to Firestore only when score changes, after frame renders
          final newScore = overallPct * 100;
          if (newScore != _lastSavedScore) {
            _lastSavedScore = newScore;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _checklistService.saveReadinessScore(newScore);
            });
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _Header(
                  spiritualPct: pct(spiritual),
                  financialPct: pct(financial),
                  personalPct:  pct(personal),
                  overallPct:   overallPct,
                ),
              ),

              if (tasks.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.checklist_rounded, size: 56, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text(
                          "No tasks yet",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Tap + to add your first readiness task",
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              if (tasks.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (spiritual.isNotEmpty) ...[
                        _SectionTitle(title: "SPIRITUAL", color: const Color(0xFF8C79B6)),
                        ...spiritual.map((t) => _TaskCard(
                          task: t,
                          service: _checklistService,
                          onEdit: () => _showEditTaskDialog(context, t),
                        )),
                      ],
                      if (financial.isNotEmpty) ...[
                        _SectionTitle(title: "FINANCIAL", color: const Color(0xFF0F6E56)),
                        ...financial.map((t) => _TaskCard(
                          task: t,
                          service: _checklistService,
                          onEdit: () => _showEditTaskDialog(context, t),
                        )),
                      ],
                      if (personal.isNotEmpty) ...[
                        _SectionTitle(title: "PERSONAL", color: const Color(0xFF993556)),
                        ...personal.map((t) => _TaskCard(
                          task: t,
                          service: _checklistService,
                          onEdit: () => _showEditTaskDialog(context, t),
                        )),
                      ],
                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF9B7EBD),
        elevation: 4,
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final controller = TextEditingController();
    String selectedCategory = "Spiritual";
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Add New Task",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "e.g. Complete premarital course",
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade400),
                  errorText: errorText,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9B7EBD), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                onChanged: (_) {
                  if (errorText != null) setState(() => errorText = null);
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: GoogleFonts.poppins(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF9B7EBD), width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                items: ["Spiritual", "Financial", "Personal"]
                    .map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s, style: GoogleFonts.poppins(fontSize: 14)),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => selectedCategory = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B7EBD),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final title = controller.text.trim();
                if (title.isEmpty) {
                  setState(() => errorText = "Task name cannot be empty");
                  return;
                }
                _checklistService.addTask(title, selectedCategory);
                Navigator.pop(context);
              },
              child: Text("Add", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, ChecklistTask task) {
    final controller = TextEditingController(text: task.title);
    String? errorText;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            "Edit Task",
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          content: TextField(
            controller: controller,
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            decoration: InputDecoration(
              hintText: "Task name",
              errorText: errorText,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF9B7EBD), width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
            onChanged: (_) {
              if (errorText != null) setState(() => errorText = null);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B7EBD),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                final newTitle = controller.text.trim();
                if (newTitle.isEmpty) {
                  setState(() => errorText = "Task name cannot be empty");
                  return;
                }
                _checklistService.editTask(task.id, newTitle);
                Navigator.pop(context);
              },
              child: Text("Save", style: GoogleFonts.poppins(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

// ── HEADER ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final double spiritualPct, financialPct, personalPct, overallPct;
  const _Header({
    required this.spiritualPct,
    required this.financialPct,
    required this.personalPct,
    required this.overallPct,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF1FF), Color(0xFFFDFBFD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PREPARATION",
            style: GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w700,
              letterSpacing: 1.8, color: const Color(0xFF8C79B6),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Readiness\nChecklist",
            style: GoogleFonts.playfairDisplay(
              fontSize: 34, fontWeight: FontWeight.bold,
              color: const Color(0xFF2C1B4D), height: 1.1,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(child: _CategoryRing(label: "Spiritual", percent: spiritualPct, color: const Color(0xFF9B7EBD))),
              const SizedBox(width: 10),
              Expanded(child: _CategoryRing(label: "Financial", percent: financialPct, color: const Color(0xFF1D9E75))),
              const SizedBox(width: 10),
              Expanded(child: _CategoryRing(label: "Personal",  percent: personalPct,  color: const Color(0xFFD4537E))),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${(overallPct * 100).toInt()}%",
                      style: GoogleFonts.poppins(
                        fontSize: 24, fontWeight: FontWeight.bold,
                        color: const Color(0xFF2C1B4D),
                      ),
                    ),
                    Text(
                      "Overall readiness",
                      style: GoogleFonts.poppins(
                        fontSize: 11, color: const Color(0xFF7A6A9C),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: overallPct,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFDDD8F0),
                      valueColor: const AlwaysStoppedAnimation(Color(0xFF9B7EBD)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── CATEGORY RING ─────────────────────────────────────────────────────────────
class _CategoryRing extends StatelessWidget {
  final String label;
  final double percent;
  final Color color;
  const _CategoryRing({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 58, height: 58,
            child: CustomPaint(
              painter: _RingPainter(percent: percent, color: color),
              child: Center(
                child: Text(
                  "${(percent * 100).toInt()}%",
                  style: GoogleFonts.poppins(
                    fontSize: 12, fontWeight: FontWeight.bold,
                    color: const Color(0xFF2C1B4D),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10, fontWeight: FontWeight.w600,
              letterSpacing: 0.6, color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double percent;
  final Color color;
  const _RingPainter({required this.percent, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;
    const strokeWidth = 6.0;

    canvas.drawCircle(center, radius, Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth);

    if (percent > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * percent,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.percent != percent || old.color != color;
}

// ── SECTION TITLE ─────────────────────────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;
  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Row(
        children: [
          Container(width: 3, height: 14, color: color, margin: const EdgeInsets.only(right: 8)),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11, fontWeight: FontWeight.w700,
              letterSpacing: 1.4, color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── TASK CARD ─────────────────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final ChecklistTask task;
  final ChecklistService service;
  final VoidCallback onEdit;
  const _TaskCard({required this.task, required this.service, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8, offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: GestureDetector(
          onTap: () => service.toggleTaskStatus(task.id, task.isCompleted),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 28, height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isCompleted ? const Color(0xFF9B7EBD) : Colors.transparent,
              border: Border.all(color: const Color(0xFF9B7EBD), width: 2),
            ),
            child: Icon(
              Icons.check,
              size: 15,
              color: task.isCompleted ? Colors.white : Colors.transparent,
            ),
          ),
        ),
        title: Text(
          task.title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: task.isCompleted ? Colors.grey.shade400 : const Color(0xFF2C1B4D),
            decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            decorationColor: Colors.grey.shade400,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 18, color: Color(0xFF9B7EBD)),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Color(0xFFD4537E)),
              onPressed: () => _confirmDelete(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("Delete Task", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(
          "Remove \"${task.title}\"?",
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4537E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              service.deleteTask(task.id);
              Navigator.pop(context);
            },
            child: Text("Delete", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}