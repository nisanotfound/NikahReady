import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../services/wedding_provider.dart';
import '../../widgets/wedding_dialogs.dart';

class PlannerScreen extends StatelessWidget {
  const PlannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to real-time changes inside the WeddingProvider state manager
    final provider = context.watch<WeddingProvider>();

    // Calculate dynamic guest counts for RSVP tracking
    final totalGuests = provider.guests.length;
    final confirmedGuests = provider.guests.where((g) => g.status == 'Confirmed').length;
    final pendingGuests = provider.guests.where((g) => g.status == 'Pending').length;

    // Determine the dynamic remaining countdown days or default to a 42-day placeholder
    final daysLeft = provider.daysUntilWedding ?? 42; 
    
    // Format the date picker string safely or display a placeholder if not set
    final formattedDate = provider.weddingDate != null 
        ? "${provider.weddingDate!.day}/${provider.weddingDate!.month}/${provider.weddingDate!.year}"
        : "Please set a wedding date";

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // =========================================================================
                  // 👋 HERO SECTION: WEDDING COUNTDOWN CARD
                  // =========================================================================
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 60, 24, 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEAF8F5), Color(0xFFE4F3FA)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF5A8F7B).withOpacity(0.08),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left side: Wedding Title & Interactive Date Picker
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "WEDDING PLANNER",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                    color: const Color(0xFF5A8F7B),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Solemnization",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    height: 1.1,
                                    color: const Color(0xFF1E3A34),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                GestureDetector(
                                  onTap: () async {
                                    final picked = await showDatePicker(
                                      context: context,
                                      initialDate: provider.weddingDate ?? DateTime.now().add(const Duration(days: 90)),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now().add(const Duration(days: 1825)),
                                    );
                                    if (picked != null) provider.setWeddingDate(picked);
                                  },
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_month_outlined, size: 14, color: Color(0xFF62877F)),
                                      const SizedBox(width: 4),
                                      Text(
                                        formattedDate,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF62877F),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Right side: Visual Remaining Days Counter Box
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.65),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.5)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$daysLeft",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF1E3A34),
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "Days Left",
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF5A8F7B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =========================================================================
                  // 💰 BUDGET TRACKER & SEPARATED EXPENSES
                  // =========================================================================
                  _buildSectionContainer(
                    title: "BUDGET TRACKER",
                    trailing: Row(
                      children: [
                        // Button to add a new standalone expense
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: Color(0xFF7FA196), size: 20),
                          onPressed: () async {
                            final draft = await showAddExpenseDialog(context);
                            if (draft != null) {
                              provider.addExpense(
                                category: draft.category,
                                description: draft.description,
                                amount: draft.amount,
                              );
                            }
                          },
                        ),
                        // Button to modify overall total budget limit
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Colors.grey, size: 18),
                          onPressed: () async {
                            final value = await showSetBudgetDialog(context, provider.totalBudget);
                            if (value != null && value >= 0) provider.setTotalBudget(value);
                          },
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Expenses & Budget", style: GoogleFonts.playfairDisplay(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1E3A34))),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "RM ${provider.totalSpent.toStringAsFixed(2)} ", 
                                style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2C1B4D)),
                              ),
                              TextSpan(
                                text: "/ RM ${provider.totalBudget.toStringAsFixed(2)}", 
                                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBudgetSubStat("Paid", "RM ${provider.totalSpent.toStringAsFixed(0)}", const Color(0xFF2D6A53)),
                            _buildBudgetSubStat("Remaining", "RM ${provider.budgetRemaining.toStringAsFixed(0)}", const Color(0xFFD48C46)),
                          ],
                        ),
                        
                        // Displays the list of added items up to a maximum of 3 items
                        if (provider.expenses.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 8),
                            child: Divider(color: Color(0xFFF0EBF5)),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.expenses.length > 3 ? 3 : provider.expenses.length,
                            itemBuilder: (context, index) {
                              final expense = provider.expenses[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFEAF8F5), borderRadius: BorderRadius.circular(8)),
                                  child: Text(expense.category, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2D6A53))),
                                ),
                                title: Text(expense.description, style: GoogleFonts.poppins(fontSize: 13)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("RM ${expense.amount.toStringAsFixed(0)}", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold)),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 14, color: Colors.grey),
                                      onPressed: () => provider.removeExpense(expense.id),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),

                  // =========================================================================
                  // ✅ WEDDING CHECKLIST & TO-DO MANAGEMENT
                  // =========================================================================
                  _buildSectionContainer(
                    title: "WEDDING CHECKLIST",
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF7FA196), size: 20),
                      onPressed: () async {
                        final draft = await showAddTaskDialog(context);
                        if (draft != null) provider.addTask(title: draft.title, dueDate: draft.dueDate);
                      },
                    ),
                    child: provider.tasks.isEmpty
                        ? const Text("No tasks added yet.", style: TextStyle(color: Colors.grey))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: provider.tasks.length,
                            itemBuilder: (context, index) {
                              final task = provider.tasks[index];
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: IconButton(
                                  icon: Icon(task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank, color: const Color(0xFF2D6A53)),
                                  onPressed: () => provider.toggleTask(task.id),
                                ),
                                title: Text(task.title, style: GoogleFonts.poppins(fontSize: 14, decoration: task.isCompleted ? TextDecoration.lineThrough : null)),
                                trailing: Text("${task.dueDate.day}/${task.dueDate.month}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              );
                            },
                          ),
                  ),

                  // =========================================================================
                  // 📅 UPCOMING REMINDERS (Automated incomplete logs selector)
                  // =========================================================================
                  _buildSectionContainer(
                    title: "UPCOMING REMINDERS",
                    child: provider.tasks.where((t) => !t.isCompleted).isEmpty
                        ? const Text("No upcoming reminders at this time.", style: TextStyle(color: Colors.grey))
                        : Column(
                            children: provider.tasks.where((t) => !t.isCompleted).take(3).map((task) {
                              return _buildReminderRow(task.title, "${task.dueDate.day}/${task.dueDate.month}", Icons.notification_important_rounded);
                            }).toList(),
                          ),
                  ),

                  // =========================================================================
                  // 👥 GUEST MANAGEMENT (RSVP Metrics Overview)
                  // =========================================================================
                  _buildSectionContainer(
                    title: "GUEST MANAGEMENT",
                    trailing: IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: Color(0xFF7FA196), size: 20),
                      onPressed: () async {
                        final result = await showAddGuestDialog(context);
                        if (result != null) provider.addGuest(result['name']!, result['status']!);
                      },
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildGuestStat("$totalGuests", "Total Guests", Colors.blueGrey),
                        _buildGuestStat("$confirmedGuests", "Confirmed", const Color(0xFF2D6A53)),
                        _buildGuestStat("$pendingGuests", "Pending", const Color(0xFFD48C46)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
    );
  }

  // =========================================================================
  // --- REUSABLE HELPER VIEW COMPONENT METHODS ---
  // =========================================================================

  /// Wrapper template to build cards with a header title, custom content and optional trailing actions
  Widget _buildSectionContainer({required String title, required Widget child, Widget? trailing, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF0EBF5)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: const Color(0xFF7FA196))),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  /// Label element block for sub-financial balance states (Paid/Remaining)
  Widget _buildBudgetSubStat(String status, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(amount, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
        Text(status, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
      ],
    );
  }

  /// Compact rows representing urgent checklist schedules inside the upcoming alert logs box
  Widget _buildReminderRow(String text, String date, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF9B7EBD)),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 13))),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  /// Grid summary items showing status counts inside Guest Management
  Widget _buildGuestStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}