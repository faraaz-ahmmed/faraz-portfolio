import 'package:firebase_auth/firebase_auth.dart';

import '../config/admin_config.dart';

// Authentication Service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Admin Status Section
  bool get isAdmin => _auth.currentUser?.uid == AdminConfig.uid;
  // Admin Status End

  // Login Section
  Future<void> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    if (result.user?.uid != AdminConfig.uid) {
      await _auth.signOut();

      throw FirebaseAuthException(
        code: 'admin-only',
        message: 'This account does not have admin access.',
      );
    }
  }
  // Login End

  // Logout Section
  Future<void> logout() async {
    await _auth.signOut();
  }
  // Logout End
}
// Authentication Service End