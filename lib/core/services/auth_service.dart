import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:smartlib/common/models/user_model.dart';
import 'package:smartlib/firestore_service.dart';

class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  Stream<fb_auth.User?> get userStream => _auth.authStateChanges();
  fb_auth.User? get currentUser => _auth.currentUser;

  Future<fb_auth.User?> login(String email, String password) async {
    try {
      fb_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print('Login error: $e');
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<fb_auth.User?> register(String email, String password, String firstName, String lastName, String username, String phoneNumber) async {
    try {
      fb_auth.UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = result.user;

      if (firebaseUser != null) {
        final newUser = User(
          id: firebaseUser.uid,
          firstName: firstName,
          lastName: lastName,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
        );
        await _firestoreService.saveUserData(newUser);
      }
      return firebaseUser;
    } on fb_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      }
      throw Exception('Registration failed: ${e.message}');
    } catch (e) {
      print('Registration error: $e');
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final credential = fb_auth.EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        print('Password updated successfully!');
      } on fb_auth.FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          throw Exception('Password lama salah.');
        } else if (e.code == 'requires-recent-login') {
          throw Exception('Mohon login ulang untuk mengubah password Anda.');
        } else if (e.code == 'weak-password') {
          throw Exception('Password baru terlalu lemah.');
        } else {
          throw Exception('Gagal mengubah password: ${e.message}');
        }
      } catch (e) {
        print('Error changing password: $e');
        throw Exception('Terjadi kesalahan saat mengubah password: ${e.toString()}');
      }
    } else {
      throw Exception('Tidak ada user yang sedang login.');
    }
  }

  // --- TAMBAHKAN FUNGSI DELETE ACCOUNT DI SINI ---
  Future<void> deleteAccount(String password) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        // 1. Re-authenticate pengguna sebelum menghapus akun
        // Ini adalah langkah keamanan penting untuk operasi sensitif
        final credential = fb_auth.EmailAuthProvider.credential(
          email: user.email!, // Email user yang sedang login
          password: password, // Password lama yang dimasukkan user
        );
        await user.reauthenticateWithCredential(credential);

        // 2. Hapus dokumen pengguna dari Firestore
        // Ini harus dilakukan SEBELUM menghapus akun Firebase Auth,
        // karena setelah akun Auth dihapus, user.uid akan hilang.
        await _firestoreService.deleteUserData(user.uid);

        // 3. Hapus akun dari Firebase Authentication
        await user.delete();
        print('Account deleted successfully!');
      } on fb_auth.FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          throw Exception('Mohon login ulang dan konfirmasi password Anda untuk menghapus akun.');
        } else if (e.code == 'wrong-password') {
          throw Exception('Password yang Anda masukkan salah.');
        } else {
          throw Exception('Gagal menghapus akun: ${e.message}');
        }
      } catch (e) {
        print('Error deleting account: $e');
        throw Exception('Terjadi kesalahan saat menghapus akun: ${e.toString()}');
      }
    } else {
      throw Exception('Tidak ada user yang sedang login.');
    }
  }
  // --- AKHIR TAMBAHAN ---

  Future<void> logout() async {
    await _auth.signOut();
  }
}