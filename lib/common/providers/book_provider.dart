// lib/common/providers/book_provider.dart
import 'package:flutter/material.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // <-- Import Firebase Auth

class BookProvider with ChangeNotifier {
  final FirestoreService _firestoreService;
  final firebase_auth.FirebaseAuth _firebaseAuth; // <-- Tambahkan ini

  // Constructor baru untuk menerima FirestoreService DAN FirebaseAuth
  BookProvider(this._firestoreService, this._firebaseAuth); // <-- Ubah constructor

  String? get _currentUserId => _firebaseAuth.currentUser?.uid; // <-- Getter untuk ID user

  final List<Book> _favoriteBooks = [];
  final List<Book> _toReadListBooks = [];
  final List<Book> _finishedBooks = [];

  List<Book> get favoriteBooks => _favoriteBooks;
  List<Book> get toReadListBooks => _toReadListBooks;
  List<Book> get finishedBooks => _finishedBooks;

  // Pastikan Anda memuat buku saat provider diinisialisasi atau saat user login
  // Anda mungkin ingin memanggil fetchBooksFromFirebase() di sini atau di main.dart
  // setelah user login.
  void initializeBooks() {
    _firebaseAuth.authStateChanges().listen((firebase_auth.User? firebaseUser) {
      if (firebaseUser != null) {
        fetchBooksFromFirebase(); // Muat buku saat user login
      } else {
        // Clear lists jika user logout
        _favoriteBooks.clear();
        _toReadListBooks.clear();
        _finishedBooks.clear();
        notifyListeners();
      }
    });
  }

  void toggleFavorite(Book book) {
    if (isFavorite(book)) {
      _favoriteBooks.removeWhere((b) => b.title == book.title);
    } else {
      _favoriteBooks.add(book);
    }
    notifyListeners();
  }

  bool isFavorite(Book book) {
    return _favoriteBooks.any((b) => b.title == book.title);
  }

  void addToReadList(Book book) async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint("❌ Tidak ada pengguna yang login. Tidak bisa menambahkan buku.");
      return;
    }

    if (_toReadListBooks.any((b) => b.title == book.title)) {
      debugPrint("⚠️ Buku '${book.title}' sudah ada di daftar baca lokal.");
      return;
    }

    _toReadListBooks.add(book);
    notifyListeners();

    try {
      await _firestoreService.saveBook(userId, book); // <-- Kirim userId
      debugPrint("✅ Buku '${book.title}' berhasil disimpan ke Firestore untuk user $userId.");
    } catch (e) {
      debugPrint("❌ Gagal menyimpan buku '${book.title}' ke Firestore untuk user $userId: $e");
      _toReadListBooks.removeWhere((b) => b.title == book.title);
      notifyListeners();
    }
  }

  void markAsFinished(Book book) {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint("❌ Tidak ada pengguna yang login. Tidak bisa memperbarui status buku.");
      return;
    }

    final index = _toReadListBooks.indexWhere((b) => b.title == book.title);
    if (index != -1) {
      _toReadListBooks.removeAt(index);
      _finishedBooks.add(book);
      notifyListeners();

      _firestoreService.updateBookStatus(userId, book.title, 'finished'); // <-- Kirim userId
      debugPrint("✅ Buku '${book.title}' ditandai sebagai selesai untuk user $userId.");
    } else {
      debugPrint("⚠️ Buku '${book.title}' tidak ditemukan di daftar baca untuk ditandai selesai.");
    }
  }
  
  void unmarkAsFinished(Book book) {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint("❌ Tidak ada pengguna yang login. Tidak bisa membatalkan status selesai.");
      return;
    }


    final index = _finishedBooks.indexWhere((b) => b.title == book.title);
    if (index != -1) {
      _finishedBooks.removeAt(index);
      _toReadListBooks.add(book);
      notifyListeners();

      _firestoreService.updateBookStatus(userId, book.title, 'to_read'); // <-- Kirim userId
      debugPrint("✅ Buku '${book.title}' dikembalikan ke daftar baca untuk user $userId.");
    } else {
      debugPrint("⚠️ Buku '${book.title}' tidak ditemukan di daftar selesai untuk dikembalikan.");
    }
  }

  void addReview(Book book, int rating, String reviewText) {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint("❌ Tidak ada pengguna yang login. Tidak bisa menambahkan ulasan.");
      return;
    }

    int index = _finishedBooks.indexWhere((b) => b.title == book.title);
    if (index != -1) {
      _finishedBooks[index].rating = rating;
      _finishedBooks[index].reviewText = reviewText;
      notifyListeners();

      _firestoreService.updateBookReview(userId, book.title, rating, reviewText); // <-- Kirim userId
      debugPrint("✅ Ulasan untuk buku '${book.title}' berhasil ditambahkan/diperbarui untuk user $userId.");
    } else {
      debugPrint("⚠️ Buku '${book.title}' tidak ditemukan di daftar selesai untuk menambahkan ulasan.");
    }
  }

  Future<void> fetchBooksFromFirebase() async {
    final userId = _currentUserId;
    if (userId == null) {
      debugPrint("❌ Tidak ada pengguna yang login. Tidak bisa mengambil buku dari Firebase.");
      return;
    }

    try {
      final List<Book> fetchedBooks = await _firestoreService.getAllBooks(userId); // <-- Kirim userId
      _toReadListBooks.clear();
      _finishedBooks.clear();
      for (var book in fetchedBooks) {
        if (book.toMap().containsKey('status') && book.toMap()['status'] == 'finished') {
          _finishedBooks.add(book);
        } else {
          _toReadListBooks.add(book);
        }
      }
      debugPrint("✅ Berhasil mengambil ${fetchedBooks.length} buku dari Firestore untuk user $userId.");
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Gagal mengambil data dari Firebase untuk user $userId: $e");
    }
  }
  Future<void> removeFromToReadList(Book book) async {
  final userId = _currentUserId;
  if (userId == null) {
    debugPrint("❌ Tidak ada user login.");
    return;
  }

  _toReadListBooks.removeWhere((b) => b.title == book.title);
  notifyListeners();

  try {
    await _firestoreService.deleteBook(userId, book.title); // pastikan method ini ada
    debugPrint("✅ Buku '${book.title}' berhasil dihapus dari Firestore.");
  } catch (e) {
    debugPrint("❌ Gagal menghapus buku '${book.title}': $e");
  }
}

}