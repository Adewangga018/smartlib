// firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlib/common/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection => _db.collection('users');

  Future<void> saveUserData(User user) async {
    await _usersCollection.doc(user.id).set(user.toFirestore());
  }

  Future<User?> getUserData(String uid) async {
    try {
      final docSnapshot = await _usersCollection.doc(uid).get();
      if (docSnapshot.exists) {
        return User.fromFirestore(docSnapshot.data()!, docSnapshot.id);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<void> updateUserData(User user) async {
    if (user.id.isEmpty) {
      throw Exception('User ID is missing for update operation.');
    }
    await _usersCollection.doc(user.id).update(user.toFirestore());
  }

  // --- TAMBAHKAN FUNGSI DELETE USER DATA DI SINI ---
  Future<void> deleteUserData(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
      print('User data for $uid deleted from Firestore.');
    } catch (e) {
      print('Error deleting user data from Firestore: $e');
      throw Exception('Failed to delete user data: ${e.toString()}');
    }
  }
  // --- AKHIR TAMBAHAN ---

  // TAMBAHAN: Fungsi untuk memperbarui hanya foto profil
  Future<void> updateUserProfilePhoto(String uid, String? photoUrl) async {
    try {
      await _usersCollection.doc(uid).update({
        'photoUrl': photoUrl,
      });
    } catch (e) {
      print('Error updating profile photo: $e');
      throw Exception('Failed to update profile photo: ${e.toString()}');
    }
  }
}