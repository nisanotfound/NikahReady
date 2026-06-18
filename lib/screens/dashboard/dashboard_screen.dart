import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

import 'settings_screen.dart'; 
import '../mahr/mahr_screen.dart';
import '../checklist/checklist_screen.dart';
import '../quiz_screen.dart';
import '../planner_screen.dart'; 

import '../../services/wedding_provider.dart';
import '../../services/checklist_service.dart';
import '../../models/checklist_model.dart';     
import '../../providers/quiz_provider.dart'; 
import '../../providers/mahr_provider.dart'; 
import '../../providers/readiness_provider.dart'; 

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0: return const ChecklistScreen();
      case 1: return const MahrScreen();
      case 2: return _buildMainDashboard();
      case 3: return const PlannerScreen(); 
      case 4: return const QuizScreen();
      default: return _buildMainDashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHomeSelected = _selectedIndex == 2;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: _getSelectedScreen(_selectedIndex),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: isHomeSelected ? const Color(0xFF9B7EBD) : Colors.grey.shade400,
        elevation: isHomeSelected ? 4 : 0,
        shape: const CircleBorder(), 
        child: const Icon(Icons.home_rounded, color: Colors.white, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0, 
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 65,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: [
              _buildNavItem(icon: Icons.list_alt_rounded, label: 'List', index: 0),
              _buildNavItem(icon: Icons.calculate_outlined, label: 'Mahr', index: 1),
              const SizedBox(width: 48), 
              _buildNavItem(icon: Icons.calendar_today_outlined, label: 'Plan', index: 3),
              _buildNavItem(icon: Icons.help_outline_rounded, label: 'Quiz', index: 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? const Color(0xFF9B7EBD) : Colors.grey.shade400;
    
    return InkWell(
      onTap: () => _onItemTapped(index),
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent, 
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label, 
            style: GoogleFonts.poppins(
              fontSize: 10, 
              color: color, 
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal
            )
          ),
        ],
      ),
    );
  }

  Widget _buildMainDashboard() {
    final weddingProvider = context.watch<WeddingProvider>();
    final quizProvider = context.watch<QuizProvider>();
    final mahrProvider = context.watch<MahrProvider>();
    final readinessProvider = context.read<ReadinessProvider>(); 

    final daysLeft = weddingProvider.daysUntilWedding;
    final countdownText = daysLeft != null ? "${daysLeft}d" : "42d";

    // 4. Dapatkan User ID yang sedang login
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Center(child: CircularProgressIndicator()); 

    final checklistService = ChecklistService(userId: user.uid);

    // 5. Wrap (Bungkus) UI Dashboard dengan StreamBuilder supaya data Live
    return StreamBuilder<List<ChecklistTask>>(
      stream: checklistService.getTasks(),
      builder: (context, snapshot) {
        
        // Kira Task dari Firebase
        final tasks = snapshot.data ?? [];
        final totalTasks = tasks.length;
        final completedTasks = tasks.where((t) => t.isCompleted).length;

        // Gunakan ReadinessProvider
        final int spiritualScore = readinessProvider.calculateSpiritual(quizProvider.totalQuestions, quizProvider.correctCount);
        final int financialScore = readinessProvider.calculateFinancial(mahrProvider.mahr.currentSavings, mahrProvider.mahr.targetMahr);
        final int personalScore = readinessProvider.calculatePersonal(totalTasks, completedTasks);
        
        final int overallReadiness = readinessProvider.calculateOverall(spiritualScore, financialScore, personalScore);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFEAF1FF), Color(0xFFFDE8F1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("NIKAHREADY", style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: const Color(0xFF8C79B6))),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.settings_outlined, color: Color(0xFF2C1B4D), size: 34),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text("Your journey\nstarts here", style: GoogleFonts.playfairDisplay(fontSize: 38, fontWeight: FontWeight.bold, height: 1.1, color: const Color(0xFF2C1B4D))),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("$overallReadiness", style: GoogleFonts.playfairDisplay(fontSize: 85, fontWeight: FontWeight.bold, color: const Color(0xFF9B7EBD), height: 1)),
                        Padding(padding: const EdgeInsets.only(bottom: 12, left: 4), child: Text("%", style: GoogleFonts.playfairDisplay(fontSize: 40, fontWeight: FontWeight.bold, color: const Color(0xFF9B7EBD)))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text("OVERALL READINESS", style: GoogleFonts.poppins(fontSize: 12, letterSpacing: 1.5, fontWeight: FontWeight.w500, color: const Color(0xFF9B7EBD))),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _statBox("$spiritualScore%", "Spiritual", const Color(0xFFF1F1FE), const Color(0xFF5C4E9A))), 
                        const SizedBox(width: 16), 
                        Expanded(child: _statBox("$financialScore%", "Financial", const Color(0xFFFFF2F2), const Color(0xFFA95C5C)))
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _statBox("$personalScore%", "Personal", const Color(0xFFF1F9FE), const Color(0xFF3886A9))), 
                        const SizedBox(width: 16), 
                        Expanded(child: _statBox(countdownText, "To nikah", const Color(0xFFF1FEF4), const Color(0xFF257545)))
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _actionRow(
                      icon: Icons.checklist_rounded, 
                      title: "My checklist", 
                      subtitle: "${totalTasks - completedTasks} tasks left", 
                      iconBg: const Color(0xFFF1F1FE), 
                      onTap: () => _onItemTapped(0),
                    ),
                    const SizedBox(height: 16),
                    _actionRow(
                      icon: Icons.menu_book_rounded, 
                      title: "Today's quiz", 
                      subtitle: "Marriage conditions", 
                      iconBg: const Color(0xFFFFF2F2), 
                      onTap: () => _onItemTapped(4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        );
      }
    );
  }

  Widget _statBox(String value, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(24)),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: textColor)), 
          Text(label, style: GoogleFonts.poppins(fontSize: 14, color: textColor.withValues(alpha: 0.8)))
        ],
      ),
    );
  }

  Widget _actionRow({required IconData icon, required String title, required String subtitle, required Color iconBg, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(24), 
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))
          ]
        ),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFF2C1B4D), size: 22)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF2C1B4D))), Text(subtitle, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey))])),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}