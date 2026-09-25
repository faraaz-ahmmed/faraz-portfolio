import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/profile_model.dart';
import '../services/profile_service.dart';

// Profile ViewModel
class ProfileViewModel extends ChangeNotifier {
  final ProfileService _service = ProfileService();
  StreamSubscription<ProfileModel?>? _subscription;

  bool _disposed = false;

  // Default Profile Section
  static const _defaultProfile = ProfileModel(
    name: 'Faraz Ahmad',
    role: 'Flutter Developer',
    bio: 'I am a Computer Science graduate from the University '
        'of Agriculture Peshawar. I enjoy building clean, '
        'user-friendly apps with Flutter and Firebase.',
    skills: ['Flutter', 'Dart', 'Firebase', 'Git'],
  );
  // Default Profile End

  // Profile State Section
  ProfileModel _profile = _defaultProfile;

  bool _isLoading = true;
  bool _isSaving = false;

  String? _loadError;
  String? _saveError;

  ProfileModel get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get loadError => _loadError;
  String? get saveError => _saveError;
  // Profile State End

  // Load Profile Section
  ProfileViewModel() {
    _subscription = _service.watchProfile().listen(
      (profile) {
        if (_disposed) return;

        _profile = profile ?? _defaultProfile;
        _isLoading = false;
        _loadError = null;
        notifyListeners();
      },
      onError: (Object error) {
        if (_disposed) return;

        _isLoading = false;
        _loadError = 'Unable to load profile. Check your connection.';
        notifyListeners();
      },
    );
  }
  // Load Profile End

  // Save Profile Section
  Future<bool> updateProfile(ProfileModel profile) async {
    if (_isSaving || _disposed) return false;

    _isSaving = true;
    _saveError = null;
    notifyListeners();

    try {
      await _service.saveProfile(profile);
      return true;
    } catch (_) {
      _saveError = 'Unable to save profile. Please try again.';
      return false;
    } finally {
      _isSaving = false;

      if (!_disposed) {
        notifyListeners();
      }
    }
  }
  // Save Profile End

  // Cleanup Section
  @override
  void dispose() {
    _disposed = true;
    _subscription?.cancel();
    super.dispose();
  }
  // Cleanup End
}
// Profile ViewModel End