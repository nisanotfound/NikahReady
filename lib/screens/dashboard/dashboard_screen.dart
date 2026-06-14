import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_screen.dart'; // Pastikan fail ini wujud

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2; // Dashboard Utama

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: _selectedIndex == 2 
          ? _buildMainDashboard() 
          : Center(child: Text("Screen Index: $_selectedIndex")),

      // Navigasi Bawah mengikut gambar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF9B7EBD),
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: 'List'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate_outlined), label: 'Mahr'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: 'Plan'),
        ],
      ),
    );
  }

  Widget _buildMainDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER SECTION (Gradient)
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
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NIKAHREADY",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: const Color(0xFF8C79B6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Your journey\nstarts here",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                        color: const Color(0xFF2C1B4D),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "72",
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 85,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF9B7EBD),
                            height: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 4),
                          child: Text(
                            "%",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF9B7EBD),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "OVERALL READINESS",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9B7EBD),
                      ),
                    ),
                  ],
                ),
                
                // TAMBAHAN: Butang Settings di penjuru kanan
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Color(0xFF2C1B4D), size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // STATISTICS GRID (4 Kotak)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _statBox("80%", "Spiritual", const Color(0xFFF1F1FE), const Color(0xFF5C4E9A))),
                    const SizedBox(width: 16),
                    Expanded(child: _statBox("65%", "Financial", const Color(0xFFFFF2F2), const Color(0xFFA95C5C))),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _statBox("71%", "Personal", const Color(0xFFF1F9FE), const Color(0xFF3886A9))),
                    const SizedBox(width: 16),
                    Expanded(child: _statBox("42d", "To nikah", const Color(0xFFF1FEF4), const Color(0xFF257545))),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // SHORTCUT LISTS (Checklist & Quiz)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _actionRow(Icons.checklist_rounded, "My checklist", "3 tasks left", const Color(0xFFF1F1FE)),
                const SizedBox(height: 16),
                _actionRow(Icons.menu_book_rounded, "Today's quiz", "Syarat nikah", const Color(0xFFFFF2F2)),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _statBox(String value, String label, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: bgColor, 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(
            value, 
            style: GoogleFonts.playfairDisplay(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: textColor
            )
          ),
          Text(
            label, 
            style: GoogleFonts.poppins(
              fontSize: 14, 
              color: textColor.withOpacity(0.8)
            )
          ),
        ],
      ),
    );
  }

  Widget _actionRow(IconData icon, String title, String subtitle, Color iconBg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 15, 
            offset: const Offset(0, 8)
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12), 
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle), 
            child: Icon(icon, color: const Color(0xFF2C1B4D), size: 22)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: GoogleFonts.poppins(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: const Color(0xFF2C1B4D)
                  )
                ),
                Text(
                  subtitle, 
                  style: GoogleFonts.poppins(
                    fontSize: 13, 
                    color: Colors.grey
                  )
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}