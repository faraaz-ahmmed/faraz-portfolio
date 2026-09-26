import 'dart:async';

import 'package:flutter/material.dart';

import '../models/contact_model.dart';
import '../services/contact_service.dart';

// Inbox ViewModel Section

class InboxViewModel extends ChangeNotifier {
  final _service = ContactService();
  StreamSubscription<List<ContactModel>>? _subscription;

  List<ContactModel> _messages = [];
  bool _isLoading = true;
  bool _isDeleting = false;
  bool _disposed = false;
  String? _loadError;
  String? _actionError;

  List<ContactModel> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  bool get isDeleting => _isDeleting;
  String? get loadError => _loadError;
  String? get actionError => _actionError;

  // Load Messages Section

  InboxViewModel() {
    _subscription = _service.watchMessages().listen(
      (messages) {
        if (_disposed) return;

        _messages = messages;
        _isLoading = false;
        _loadError = null;
        notifyListeners();
      },
      onError: (Object error) {
        if (_disposed) return;

        _messages = [];
        _isLoading = false;
        _loadError = 'Unable to load messages.';
        notifyListeners();
      },
    );
  }

  // Load Messages End

  // Delete Message Section

  Future<bool> deleteMessage(String id) async {
    if (_isDeleting || _disposed) return false;

    _isDeleting = true;
    _actionError = null;
    notifyListeners();

    try {
      await _service.deleteMessage(id);
      return true;
    } catch (_) {
      _actionError = 'Unable to delete this message.';
      return false;
    } finally {
      _isDeleting = false;
      if (!_disposed) notifyListeners();
    }
  }

  // Delete Message End

  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
}

// Inbox ViewModel End