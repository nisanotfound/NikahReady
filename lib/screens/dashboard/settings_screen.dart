import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil data user yang sedang login
    final User? user = FirebaseAuth.instance.currentUser;

    // --- LOGIK NAMA YANG LEBIH KEBAL ---
    String displayUserName = "NikahReady User"; 
    
    if (user != null) {
      if (user.displayName != null && 
          user.displayName!.trim().isNotEmpty && 
          user.displayName != "NikahReady User") {
        // Jika ada nama yang betul-betul sah dari Firebase
        displayUserName = user.displayName!;
      } else if (user.email != null && user.email!.isNotEmpty) {
        // Jika tiada nama atau namanya masih default, paksa ambil dari e-mel
        displayUserName = user.email!.split('@')[0];
      }
    }
    // -----------------------------------

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Settings", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2C1B4D))),
        iconTheme: const IconThemeData(color: Color(0xFF2C1B4D)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // PROFILE CARD (Data Dinamik)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                children: [
                  const CircleAvatar(radius: 28, backgroundColor: Color(0xFFEAF1FF), child: Icon(Icons.person, color: Color(0xFF9B7EBD), size: 28)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Panggil pembolehubah displayUserName yang kita dah tapis di atas
                      Text(
                        displayUserName, 
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF2C1B4D))
                      ),
                      // Emel User dari Firebase
                      Text(
                        user?.email ?? "user@example.com", 
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600)
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // SETTINGS GROUP 1
            _buildSectionTitle("Account"),
            _buildMenuCard([
              _buildMenuTile(Icons.edit_outlined, "Edit Profile", () {}),
              _buildMenuTile(Icons.notifications_outlined, "Notifications", () {}),
            ]),

            const SizedBox(height: 24),

            // SETTINGS GROUP 2
            _buildSectionTitle("Security & Support"),
            _buildMenuCard([
              _buildMenuTile(Icons.lock_outline_rounded, "Privacy", () {}),
              _buildMenuTile(Icons.help_outline_rounded, "Help & Support", () {}),
              _buildMenuTile(Icons.info_outline_rounded, "About Us", () {}),
            ]),

            const SizedBox(height: 24),

            // LOGOUT BUTTON
            _buildMenuCard([
              _buildMenuTile(Icons.logout_rounded, "Sign Out", () async {
                await AuthService().signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
                }
              }, isLogout: true),
            ]),
          ],
        ),
      ),
    );
  }

  // --- Widget helper ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(title.toUpperCase(), style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.2)),
    );
  }

  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: isLogout ? Colors.redAccent : const Color(0xFF9B7EBD), size: 20),
      title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500, color: isLogout ? Colors.redAccent : const Color(0xFF2C1B4D))),
      trailing: isLogout ? null : const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
      onTap: onTap,
    );
  }
}