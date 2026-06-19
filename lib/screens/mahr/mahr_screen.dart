import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../providers/mahr_provider.dart';

class MahrScreen extends StatefulWidget {
  const MahrScreen({super.key});

  @override
  State<MahrScreen> createState() => _MahrScreenState();
}

class _MahrScreenState extends State<MahrScreen> {
  final TextEditingController savingsController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<MahrProvider>();
      await provider.loadLatestMahrGoal();

      savingsController.text = provider.mahr.currentSavings == 0
          ? ''
          : provider.mahr.currentSavings.toStringAsFixed(0);

      targetController.text = provider.mahr.targetMahr == 0
          ? ''
          : provider.mahr.targetMahr.toStringAsFixed(0);

      monthsController.text = provider.mahr.timelineMonths == 0
          ? ''
          : provider.mahr.timelineMonths.toString();
    });
  }

  void calculateMahr() {
    final double currentSavings = double.tryParse(savingsController.text) ?? 0;
    final double targetAmount = double.tryParse(targetController.text) ?? 0;
    final int months = int.tryParse(monthsController.text) ?? 0;

    context.read<MahrProvider>().calculateMahr(
          currentSavings: currentSavings,
          targetMahr: targetAmount,
          timelineMonths: months,
        );
  }

  void showFiqhNotes() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Fiqh Notes on Mahr",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Mahr is an obligatory gift from the groom to the bride in marriage. "
            "It should be agreed upon willingly and should not become a burden. "
            "The amount may be immediate or deferred depending on the agreement between both parties.",
            style: GoogleFonts.poppins(fontSize: 13, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    savingsController.dispose();
    targetController.dispose();
    monthsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mahrProvider = context.watch<MahrProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: mahrProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildInputCard(
                    title: "CURRENT SAVINGS",
                    hint: "Example: 3500",
                    controller: savingsController,
                  ),
                  _buildInputCard(
                    title: "TARGET MAHR AMOUNT",
                    hint: "Example: 10000",
                    controller: targetController,
                  ),
                  _buildInputCard(
                    title: "TIMELINE",
                    hint: "Example: 12",
                    controller: monthsController,
                  ),
                  _buildCalculateButton(),
                  _buildResultCard(),
                  _buildSaveButton(),
                  _buildInfoBox(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 28),
      decoration: const BoxDecoration(
        color: Color(0xFFFFEDED),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FINANCIAL",
            style: GoogleFonts.poppins(
              fontSize: 13,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC35B2D),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Mahr\ncalculator",
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.05,
              color: Color(0xFF4A1700),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Plan your path to readiness",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Color(0xFFD9825B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(26, 0, 26, 16),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFEDE4F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFB998D0),
            ),
          ),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (_) => calculateMahr(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2C1B4D),
            ),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: GoogleFonts.playfairDisplay(
                fontSize: 24,
                color: Colors.grey.shade300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: calculateMahr,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC35B2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            "Calculate Monthly Savings",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final monthlySavings =
        context.watch<MahrProvider>().mahr.monthlySavingsNeeded;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(26, 16, 26, 14),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFDDBF), Color(0xFFFFD4E5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          Text(
            "MONTHLY SAVINGS NEEDED",
            style: GoogleFonts.poppins(
              fontSize: 12,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC35B2D),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "RM ${monthlySavings.toStringAsFixed(2)}",
            style: GoogleFonts.playfairDisplay(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A1700),
            ),
          ),
          Text(
            "to reach your goal based on your timeline",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Color(0xFFC35B2D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    final provider = context.watch<MahrProvider>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 14),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: provider.isSaving
              ? null
              : () async {
                  calculateMahr();
                  await context.read<MahrProvider>().saveOrUpdateMahrGoal();

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Mahr goal saved/updated successfully"),
                    ),
                  );
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2C1B4D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: provider.isSaving
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  provider.mahr.id == null ? "Save Mahr Goal" : "Update Mahr Goal",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildInfoBox() {
    return GestureDetector(
      onTap: showFiqhNotes,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 26),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF5EF),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, color: Color(0xFFE0702F), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Tap here to read brief fiqh notes about mahr.",
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF994112),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}