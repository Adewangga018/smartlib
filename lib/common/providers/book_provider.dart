import 'package:flutter/material.dart';
import 'package:smartlib/common/models/book_model.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _favoriteBooks = [];
  final List<Book> _toReadListBooks = [];
  final List<Book> _finishedBooks = [];

  List<Book> get favoriteBooks => _favoriteBooks;
  List<Book> get toReadListBooks => _toReadListBooks;
  List<Book> get finishedBooks => _finishedBooks;

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

  void addToReadList(Book book) {
    if (!_toReadListBooks.any((b) => b.title == book.title)) {
      _toReadListBooks.add(book);
      notifyListeners();
    }
  }

  void removeFromReadList(Book book) {
    _toReadListBooks.removeWhere((b) => b.title == book.title);
    notifyListeners();
  }

  void markAsFinished(Book book) {
    _toReadListBooks.removeWhere((b) => b.title == book.title);
    if (!_finishedBooks.any((b) => b.title == book.title)) {
      _finishedBooks.add(book);
    }
    notifyListeners();
  }

  // --- PERUBAHAN DI SINI: Fungsi baru untuk "Un-finish" ---
  void unmarkAsFinished(Book book) {
    // Hapus dari daftar selesai
    _finishedBooks.removeWhere((b) => b.title == book.title);
    // Tambahkan kembali ke daftar to-read jika belum ada
    if (!_toReadListBooks.any((b) => b.title == book.title)) {
      _toReadListBooks.add(book);
    }
    notifyListeners();
  }
  // --- AKHIR PERUBAHAN ---

  void addReview(Book book, int rating, String reviewText) {
    int index = _finishedBooks.indexWhere((b) => b.title == book.title);
    if (index != -1) {
      _finishedBooks[index].rating = rating;
      _finishedBooks[index].reviewText = reviewText;
      notifyListeners();
    }
  }
}