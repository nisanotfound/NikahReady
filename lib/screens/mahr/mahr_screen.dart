import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MahrScreen extends StatefulWidget {
  const MahrScreen({super.key});

  @override
  State<MahrScreen> createState() => _MahrScreenState();
}

class _MahrScreenState extends State<MahrScreen> {
  final TextEditingController savingsController = TextEditingController();
  final TextEditingController targetController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();

  double monthlySavings = 0;

  void calculateMahr() {
    final double currentSavings = double.tryParse(savingsController.text) ?? 0;
    final double targetAmount = double.tryParse(targetController.text) ?? 0;
    final int months = int.tryParse(monthsController.text) ?? 0;

    setState(() {
      if (months > 0 && targetAmount > currentSavings) {
        monthlySavings = (targetAmount - currentSavings) / months;
      } else {
        monthlySavings = 0;
      }
    });
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
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: SingleChildScrollView(
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

  Widget _buildInfoBox() {
    return Container(
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
              "Mahr is an obligatory gift from the groom, agreed upon by both parties before nikah.",
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.5,
                color: Color(0xFF994112),
              ),
            ),
          ),
        ],
      ),
    );
  }
}