import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../dashboard/dashboard_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  // Variabel untuk mengawal mesej status yang comel
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
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, 
                      children: [
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
                        SizedBox(height: screenHeight * 0.03), 
                        Text(
                          "بِسْمِ اللَّهِ\nlet's plan your\nbig day 🩷",
                          textAlign: TextAlign.center, 
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 36,
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
              offset: const Offset(0, -40), 
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
                    _buildAestheticInput(
                      controller: _emailController,
                      label: "Email Address",
                      icon: Icons.favorite_border_rounded, 
                    ),
                    const SizedBox(height: 20),
                    _buildAestheticInput(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline_rounded,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF9B7EBD),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // KOTAK MESEJ CUTE DI SINI (Muncul bila ada mesej)
                    if (_statusMessage != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: _isError ? const Color(0xFFFFF2F2) : const Color(0xFFF1FEF4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                              color: _isError ? const Color(0xFFA95C5C) : const Color(0xFF257545),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _statusMessage!,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: _isError ? const Color(0xFFA95C5C) : const Color(0xFF257545),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9B7EBD), Color(0xFF8C79B6)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF9B7EBD).withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Reset mesej setiap kali tekan butang
                          setState(() {
                            _statusMessage = null;
                          });

                          if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                            setState(() {
                              _isError = true;
                              _statusMessage = "Oops! Please enter your email and password 💌";
                            });
                            return;
                          }

                          final result = await _auth.signIn(
                            _emailController.text, 
                            _passwordController.text
                          );
                          
                          if (result != null && context.mounted) {
                            Navigator.pushReplacement(
                              context, 
                              MaterialPageRoute(builder: (_) => const DashboardScreen())
                            );
                          } else {
                            setState(() {
                              _isError = true;
                              _statusMessage = "Account not found or incorrect password. Let's Sign Up first! ✨";
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, 
                          shadowColor: Colors.transparent, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), 
                          ),
                        ),
                        child: Text(
                          "Sign In", 
                          style: GoogleFonts.poppins(
                            fontSize: 16, 
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          )
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: GoogleFonts.poppins(color: Colors.grey.shade500, fontSize: 13),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Clear mesej sebelum pindah skrin
                            setState(() => _statusMessage = null);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SignUpScreen()),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: const Color(0xFF9B7EBD),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAestheticInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9FB), 
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2), 
      ),
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