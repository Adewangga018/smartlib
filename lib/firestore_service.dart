// lib/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartlib/common/models/user_model.dart';
import 'package:smartlib/common/models/book_model.dart'; // Pastikan ini ada

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CollectionReference untuk data pengguna
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _db.collection('users');

  // CollectionReference baru untuk data buku
  CollectionReference<Map<String, dynamic>> get _booksCollection =>
      _db.collection('books');

  // --- FUNGSI UNTUK USER ---
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

  Future<void> deleteUserData(String uid) async {
    try {
      await _usersCollection.doc(uid).delete();
      print('User data for $uid deleted from Firestore.');
    } catch (e) {
      print('Error deleting user data from Firestore: $e');
      throw Exception('Failed to delete user data: ${e.toString()}');
    }
  }

  // --- PERUBAHAN DI SINI: updateUserProfilePhoto menerima String? ---
  Future<void> updateUserProfilePhoto(String uid, String? photoUrl) async {
    try {
      if (photoUrl == null || photoUrl.isEmpty) {
        // Jika URL kosong atau null, hapus field 'profilePhotoUrl' dari Firestore
        await _usersCollection.doc(uid).update({'profilePhotoUrl': FieldValue.delete()});
        print('User profile photo removed for $uid.');
      } else {
        // Jika ada URL, perbarui field 'profilePhotoUrl'
        await _usersCollection.doc(uid).update({'profilePhotoUrl': photoUrl});
        print('User profile photo updated for $uid.');
      }
    } catch (e) {
      print('Error updating user profile photo: $e');
      rethrow;
    }
  }

  // --- FUNGSI UNTUK BUKU (Pastikan ini ada) ---
  Future<void> saveBook(Book book) async {
    try {
      await _booksCollection.doc(book.title).set(book.toMap());
      print('Book "${book.title}" saved/updated in Firestore.');
    } catch (e) {
      print('Error saving/updating book "${book.title}": $e');
      rethrow;
    }
  }

  Future<List<Book>> getAllBooks() async {
    try {
      final querySnapshot = await _booksCollection.get();
      return querySnapshot.docs
          .map((doc) => Book.fromMap(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting all books: $e');
      rethrow;
    }
  }

  Future<void> updateBookStatus(String bookTitle, String status) async {
    try {
      await _booksCollection.doc(bookTitle).update({'status': status});
      print('Book "${bookTitle}" status updated to "$status".');
    } catch (e) {
      print('Error updating book status for "${bookTitle}": $e');
      rethrow;
    }
  }

  Future<void> updateBookReview(
      String bookTitle, int rating, String reviewText) async {
    try {
      await _booksCollection.doc(bookTitle).update({
        'rating': rating,
        'reviewText': reviewText,
      });
      print('Book "${bookTitle}" review updated.');
    } catch (e) {
      print('Error updating book review for "${bookTitle}": $e');
      rethrow;
    }
  }

  Future<void> deleteBook(String bookTitle) async {
    try {
      await _booksCollection.doc(bookTitle).delete();
      print('Book "${bookTitle}" deleted from Firestore.');
    } catch (e) {
      print('Error deleting book "${bookTitle}": $e');
      rethrow;
    }
  }
}