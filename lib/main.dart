import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Wajib masukkan kod ini supaya Firebase berhubung dengan aplikasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NikahReadyApp());
}

class NikahReadyApp extends StatelessWidget {
  const NikahReadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NikahReady',
      theme: ThemeData(
        // Ditukar kembali kepada warna Ungu Figma untuk kesinambungan UI
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9B7EBD)), 
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFDFBFD), // Warna latar suam
        
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, 
          foregroundColor: Color(0xFF2C1B4D), // Teks ungu gelap
          elevation: 0, 
          centerTitle: true,
        ),
      ),
      home: const LoginScreen(), 
    );
  }
}