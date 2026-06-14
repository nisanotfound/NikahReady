import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Sign Up (Daftar Akaun Baru)
  Future<User?> signUp(String name, String email, String password) async {
    try {
      // Cipta akaun di Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // Simpan maklumat profil tambahan (Nama) ke dalam Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } catch (e) {
      print("Error during Sign Up: $e");
      return null;
    }
  }

  // 2. Sign In (Log Masuk)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Error during Sign In: $e");
      return null;
    }
  }

  // 3. Sign Out (Log Keluar)
  Future<void> signOut() async {
    await _auth.signOut();
  }
}