import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  ///Tambahkan ke Firebase saat ditambahkan ke daftar baca
  void addToReadList(Book book) async {
    if (!_toReadListBooks.any((b) => b.title == book.title)) {
      _toReadListBooks.add(book);
      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('books')
            .doc(book.title) // gunakan title sebagai ID dokumen
            .set(book.toMap());
      } catch (e) {
        debugPrint("Gagal menyimpan buku ke Firebase: $e");
      }
    }
  }

  void removeFromReadList(Book book) {
    _toReadListBooks.removeWhere((b) => b.title == book.title);
    notifyListeners();

    //Hapus dari Firestore juga
    FirebaseFirestore.instance.collection('books').doc(book.title).delete();
  }

  void markAsFinished(Book book) {
    _toReadListBooks.removeWhere((b) => b.title == book.title);
    if (!_finishedBooks.any((b) => b.title == book.title)) {
      _finishedBooks.add(book);
    }
    notifyListeners();
  }

  void unmarkAsFinished(Book book) {
    _finishedBooks.removeWhere((b) => b.title == book.title);
    if (!_toReadListBooks.any((b) => b.title == book.title)) {
      _toReadListBooks.add(book);
    }
    notifyListeners();
  }

  void addReview(Book book, int rating, String reviewText) {
    int index = _finishedBooks.indexWhere((b) => b.title == book.title);
    if (index != -1) {
      _finishedBooks[index].rating = rating;
      _finishedBooks[index].reviewText = reviewText;
      notifyListeners();

      // Simpan perubahan review ke Firestore
      FirebaseFirestore.instance
          .collection('books')
          .doc(book.title)
          .update({
        'rating': rating,
        'reviewText': reviewText,
      });
    }
  }

  ///Ambil data dari Firestore ke `toReadListBooks`
  Future<void> fetchBooksFromFirebase() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();
      _toReadListBooks.clear();
      for (var doc in snapshot.docs) {
        final book = Book.fromMap(doc.data());
        _toReadListBooks.add(book);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Gagal mengambil data dari Firebase: $e");
    }
  }

  ///Sinkronisasi ulang semua data lokal ke Firebase
  Future<void> syncToFirebase() async {
    for (var book in _toReadListBooks) {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(book.title)
          .set(book.toMap());
    }
  }
}
