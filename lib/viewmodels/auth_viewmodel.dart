import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

// Auth ViewModel
class AuthViewModel extends ChangeNotifier {
  final AuthService _service = AuthService();

  // Login State Section
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAdmin => _service.isAdmin;
  // Login State End

  // Login Section
  Future<bool> login(String email, String password) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.login(email, password);
      return true;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          _error = 'Please enter a valid email.';
          break;
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          _error = 'Incorrect email or password.';
          break;
        case 'admin-only':
          _error = 'Only the admin can log in.';
          break;
        case 'user-disabled':
          _error = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          _error = 'Too many attempts. Please try again later.';
          break;
        case 'network-request-failed':
          _error = 'Check your internet connection.';
          break;
        default:
          _error = 'Unable to log in. Please try again.';
      }
      return false;
    } catch (_) {
      _error = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Login End

  // Logout Section
  Future<bool> logout() async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.logout();
      return true;
    } catch (_) {
      _error = 'Unable to log out. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Logout End
}
// Auth ViewModel End