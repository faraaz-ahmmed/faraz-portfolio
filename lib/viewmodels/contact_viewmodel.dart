import 'package:flutter/material.dart';

import '../models/contact_model.dart';
import '../services/contact_service.dart';

// Contact ViewModel Section

class ContactViewModel extends ChangeNotifier {
  final _service = ContactService();

  bool _isSending = false;
  bool _disposed = false;
  String? _error;

  bool get isSending => _isSending;
  String? get error => _error;

  // Send Message Section

  Future<bool> sendMessage(ContactModel contact) async {
    if (_isSending || _disposed) return false;

    _isSending = true;
    _error = null;
    notifyListeners();

    try {
      await _service.sendMessage(contact);
      return true;
    } catch (_) {
      _error = 'Unable to send your message. Please try again.';
      return false;
    } finally {
      _isSending = false;
      if (!_disposed) notifyListeners();
    }
  }

  // Send Message End

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

// Contact ViewModel End