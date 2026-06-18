import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; 
import 'screens/auth/login_screen.dart';
import 'services/wedding_provider.dart'; 
import 'providers/readiness_provider.dart';
import 'providers/quiz_provider.dart'; // <-- 1. Import QuizProvider ditambah
import 'providers/mahr_provider.dart'; // <-- 2. Import MahrProvider ditambah

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Wajib masukkan kod ini supaya Firebase berhubung dengan aplikasi
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeddingProvider()),
        ChangeNotifierProvider(create: (_) => QuizProvider()), // <-- 3. QuizProvider didaftarkan
        ChangeNotifierProvider(create: (_) => MahrProvider()), // <-- 4. MahrProvider didaftarkan
        ChangeNotifierProvider(create: (_) => ReadinessProvider()),
      ],
      child: const NikahReadyApp(),
    ),
  );
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