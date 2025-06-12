import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final user = await _authService.login(email, password);
      _setLoading(false);
      return user != null;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString());
      return false;
    }
  }

  Future<bool> register(String email, String password, String firstName, String lastName, String username, String phoneNumber) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final user = await _authService.register(email, password, firstName, lastName, username, phoneNumber);
      _setLoading(false);
      return user != null;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString());
      return false;
    }
  }

  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.changePassword(oldPassword, newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString());
      return false;
    }
  }

  // --- TAMBAHKAN FUNGSI DELETE ACCOUNT DI SINI ---
  Future<bool> deleteAccount(String password) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      await _authService.deleteAccount(password);
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      _setErrorMessage(e.toString());
      return false;
    }
  }
  // --- AKHIR TAMBAHAN ---

  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}