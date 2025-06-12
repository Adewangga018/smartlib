import 'package:flutter/material.dart';
import 'package:smartlib/common/models/user_model.dart';
import 'package:smartlib/firestore_service.dart'; // Import FirestoreService
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Import Firebase Auth

class ProfileProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  final firebase_auth.FirebaseAuth _firebaseAuth = firebase_auth.FirebaseAuth.instance;

  User? _user; // Ubah menjadi nullable, karena data mungkin belum dimuat atau user belum login
  User? get user => _user; // Getter

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ProfileProvider(this._firestoreService) {
    // Listener untuk memuat profil setiap kali status autentikasi berubah (login/logout)
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        _loadUserProfile(firebaseUser.uid); // Muat profil jika user login
      } else {
        _user = null; // Hapus data user jika logout
        notifyListeners();
      }
    });
  }

  // Fungsi untuk mengambil data profil dari Firestore
  Future<void> _loadUserProfile(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _firestoreService.getUserData(uid);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load profile: $e';
      notifyListeners();
    }
  }

  // Fungsi untuk memperbarui profil di Firestore
  Future<void> updateUserProfile(User newUser) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (newUser.id.isEmpty) {
        throw Exception('User ID is missing for update operation.');
      }
      await _firestoreService.updateUserData(newUser);
      _user = newUser; // Perbarui data di state provider
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to update profile: $e';
      notifyListeners();
    }
  }

  // Fungsi untuk memuat ulang profil (misal setelah edit)
  Future<void> reloadUserProfile() async {
    final uid = _firebaseAuth.currentUser?.uid;
    if (uid != null) {
      await _loadUserProfile(uid);
    }
  }
}