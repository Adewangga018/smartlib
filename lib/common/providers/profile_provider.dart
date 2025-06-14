// profile_provider.dart
import 'package:flutter/material.dart';
import 'package:smartlib/common/models/user_model.dart';
import 'package:smartlib/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class ProfileProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileProvider(this._firestoreService) {
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        _loadUserProfile(firebaseUser.uid);
      } else {
        _user = null;
        notifyListeners();
      }
    });
  }

  Future<void> _loadUserProfile(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _firestoreService.getUserData(uid);
      // --- TAMBAHKAN PRINT STATEMENT DI SINI ---
      print('ProfileProvider: Loaded user photoUrl from Firestore: ${_user?.photoUrl}');
      // ----------------------------------------
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load profile: $e';
      notifyListeners();
    }
  }

  Future<void> updateUserProfile(User newUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (newUser.id.isEmpty) {
        throw Exception('User ID is missing for update operation.');
      }
      await _firestoreService.updateUserData(newUser);
      _user = newUser;
      // --- TAMBAHKAN PRINT STATEMENT DI SINI ---
      print('ProfileProvider: User profile updated, new photoUrl in state: ${_user?.photoUrl}');
      // ----------------------------------------
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update profile: $e';
      notifyListeners();
    }
  }

  Future<void> updateProfilePhoto(String? newPhotoUrl) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final uid = _firebaseAuth.currentUser?.uid;
      if (uid == null) {
        throw Exception('User not logged in.');
      }
      await _firestoreService.updateUserProfilePhoto(uid, newPhotoUrl);
      _user = _user?.copyWith(photoUrl: newPhotoUrl) ??
          User(
            id: uid,
            firstName: '',
            lastName: '',
            username: '',
            email: _firebaseAuth.currentUser!.email!,
            phoneNumber: '',
            photoUrl: newPhotoUrl,
          );
      // --- TAMBAHKAN PRINT STATEMENT DI SINI ---
      print('ProfileProvider: Profile photo updated, new photoUrl in state: ${_user?.photoUrl}');
      // ----------------------------------------
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update profile photo: $e';
      notifyListeners();
    }
  }

  Future<void> reloadUserProfile() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      await _loadUserProfile(uid);
    }
  }
}