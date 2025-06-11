import 'package:flutter/material.dart';
import 'package:smartlib/common/models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  // Data awal untuk profil pengguna
  User _user = User(
    name: 'William Sunaryo',
    username: 'KacangPanggang',
    email: 'garudarosta@gmail.com',
    phoneNumber: '081234567890',
    gender: 'Male',
  );

  // Getter untuk mengakses data pengguna
  User get user => _user;

  // Fungsi untuk memperbarui profil
  void updateUserProfile(User newUser) {
    _user = newUser;
    // Beri tahu widget yang mendengarkan untuk update!
    notifyListeners();
  }
}