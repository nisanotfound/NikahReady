import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final AuthService _auth = AuthService();

  String? _statusMessage;
  bool _isError = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBFD),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.40,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFEAF1FF), Color(0xFFFDE8F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF8C79B6), size: 20),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "NIKAHREADY",
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              color: const Color(0xFF8C79B6),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          "Start your\nnew journey ✨",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: const Color(0xFF2C1B4D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF9B7EBD).withOpacity(0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildAestheticInput(controller: _nameController, label: "Full Name", icon: Icons.person_outline_rounded),
                    const SizedBox(height: 16),
                    _buildAestheticInput(controller: _emailController, label: "Email Address", icon: Icons.favorite_border_rounded),
                    const SizedBox(height: 16),
                    _buildAestheticInput(controller: _passwordController, label: "Password", icon: Icons.lock_outline_rounded, isPassword: true),
                    const SizedBox(height: 16),
                    _buildAestheticInput(controller: _confirmPasswordController, label: "Confirm Password", icon: Icons.lock_outline_rounded, isPassword: true),
                    const SizedBox(height: 24),

                    // Mesej Status
                    if (_statusMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _isError ? const Color(0xFFFFF2F2) : const Color(0xFFF1FEF4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _statusMessage!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: _isError ? const Color(0xFFA95C5C) : const Color(0xFF257545),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(colors: [Color(0xFF9B7EBD), Color(0xFF8C79B6)]),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() => _statusMessage = null);

                          if (_passwordController.text != _confirmPasswordController.text) {
                            setState(() { _isError = true; _statusMessage = "Passwords do not match! 💔"; });
                            return;
                          }

                          if (_nameController.text.isEmpty || _emailController.text.isEmpty || _passwordController.text.isEmpty) {
                            setState(() { _isError = true; _statusMessage = "Please fill in all fields 📝"; });
                            return;
                          }

                          // MENGHANTAR 3 ARGUMEN DI SINI (DIBETULKAN)
                          final result = await _auth.signUp(
                            _nameController.text.trim(),    // Nama
                            _emailController.text.trim(),   // Email
                            _passwordController.text.trim() // Password
                          );
                          
                          if (result != null && context.mounted) {
                            // KEMASKINI NAMA DI FIREBASE
                            try {
                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await user.updateDisplayName(_nameController.text.trim());
                                await user.reload(); 
                              }
                            } catch (e) {
                              debugPrint("Error updating name: $e");
                            }

                            setState(() { _isError = false; _statusMessage = "Account created! ✨"; });
                            Future.delayed(const Duration(seconds: 2), () {
                              if (context.mounted) Navigator.pop(context);
                            });
                          } else {
                            setState(() { _isError = true; _statusMessage = "Failed to create account."; });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text("Create Account", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAestheticInput({required TextEditingController controller, required String label, required IconData icon, bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFF9F9FB), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 2)),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF2C1B4D)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF9B7EBD), size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}