// lib/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlib/common/models/user_model.dart';
import 'package:smartlib/common/models/book_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _db.collection('users');

  // --- FUNGSI UNTUK USER (TETAP SAMA) ---
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

  Future<void> saveFavorites(String userId, List<String> titles) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  await userDoc.set({'favorites': titles}, SetOptions(merge: true));
  }

  Future<List<String>> getFavorites(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists && userDoc.data()?['favorites'] != null) {
      return List<String>.from(userDoc.data()!['favorites']);
    }
    return [];
  }
  
  Future<void> updateUserData(User user) async {
    if (user.id.isEmpty) {
      throw Exception('User ID is missing for update operation.');
    }
    await _usersCollection.doc(user.id).update(user.toFirestore());
  }

  Future<void> deleteUserData(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
      print('User data for $uid deleted from Firestore.');
    } catch (e) {
      print('Error deleting user data from Firestore: $e');
      throw Exception('Failed to delete user data: ${e.toString()}');
    }
  }

  Future<void> updateUserProfilePhoto(String uid, String? photoUrl) async {
    try {
      if (photoUrl == null || photoUrl.isEmpty) {
        await _usersCollection.doc(uid).update({'profilePhotoUrl': FieldValue.delete()});
        print('User profile photo removed for $uid.');
      } else {
        await _usersCollection.doc(uid).update({'profilePhotoUrl': photoUrl});
        print('User profile photo updated for $uid.');
      }
    } catch (e) {
      print('Error updating user profile photo: $e');
      rethrow;
    }
  }

  // --- FUNGSI UNTUK BUKU (PERUBAHAN BESAR DI SINI) ---

  // Getter untuk koleksi buku yang spesifik per pengguna
  // Kini membutuhkan userId untuk mengetahui di bawah user mana buku tersebut
  CollectionReference<Map<String, dynamic>> _userBooksCollection(String userId) {
    return _usersCollection.doc(userId).collection('books');
  }

  Future<void> saveBook(String userId, Book book) async { // <-- Tambah userId
    try {
      await _userBooksCollection(userId).doc(book.title).set(book.toMap());
      print('Book "${book.title}" saved/updated for user $userId in Firestore.');
    } catch (e) {
      print('Error saving/updating book "${book.title}" for user $userId: $e');
      rethrow;
    }
  }

  Future<List<Book>> getAllBooks(String userId) async { // <-- Tambah userId
    try {
      final querySnapshot = await _userBooksCollection(userId).get();
      return querySnapshot.docs
          .map((doc) => Book.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting all books for user $userId: $e');
      rethrow;
    }
  }

  Future<void> updateBookStatus(String userId, String bookTitle, String status) async { // <-- Tambah userId
    try {
      await _userBooksCollection(userId).doc(bookTitle).update({'status': status});
      print('Book "${bookTitle}" status updated to "$status" for user $userId.');
    } catch (e) {
      print('Error updating book status for "${bookTitle}" for user $userId: $e');
      rethrow;
    }
  }

  Future<void> updateBookReview(
      String userId, String bookTitle, int rating, String reviewText) async { // <-- Tambah userId
    try {
      await _userBooksCollection(userId).doc(bookTitle).update({
        'rating': rating,
        'reviewText': reviewText,
      });
      print('Book "${bookTitle}" review updated for user $userId.');
    } catch (e) {
      print('Error updating book review for "${bookTitle}" for user $userId: $e');
      rethrow;
    }
  }

  Future<void> deleteBook(String userId, String bookTitle) async { // <-- Tambah userId
    try {
      await _userBooksCollection(userId).doc(bookTitle).delete();
      print('Book "${bookTitle}" deleted for user $userId from Firestore.');
    } catch (e) {
      print('Error deleting book "${bookTitle}" for user $userId: $e');
      rethrow;
    }
  }
}