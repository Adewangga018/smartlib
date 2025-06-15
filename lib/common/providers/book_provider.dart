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

  // Constructor untuk memuat buku saat provider diinisialisasi
  BookProvider() {
    fetchBooksFromFirebase();
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

  ///Tambahkan ke Firebase saat ditambahkan ke daftar baca
  void addToReadList(Book book) async {
    if (!_toReadListBooks.any((b) => b.title == book.title)) {
      _toReadListBooks.add(book);
      notifyListeners();

      try {
        await FirebaseFirestore.instance
            .collection('books')
            .doc(book.title) // gunakan title sebagai ID dokumen
            .set(book.toMap()); // Menggunakan toMap() yang sudah diupdate
        debugPrint("✅ Book berhasil ditambahkan ke Firestore: ${book.title}");
      } catch (e) {
        debugPrint("❌ Gagal menambahkan buku ke Firestore: $e");
      }
    }
  }

  /// Pindahkan buku dari "To-Read List" ke "Finished Books"
  void markAsFinished(Book book) async {
    _toReadListBooks.removeWhere((b) => b.title == book.title);
    // Kita membuat instance baru dari Book untuk FinishedBooks agar tidak
    // mengganggu referensi asli, terutama jika ada perubahan rating/review nantinya.
    // Dan juga memastikan info dan sinopsisnya tetap ada.
    final finishedBook = Book(
      title: book.title,
      author: book.author,
      imageUrl: book.imageUrl,
      synopsis: book.synopsis,
      info: book.info,
      rating: book.rating, // Pertahankan rating dan review yang sudah ada
      reviewText: book.reviewText,
    );

    if (!_finishedBooks.any((b) => b.title == book.title)) {
      _finishedBooks.add(finishedBook);
    }
    notifyListeners();

    // Perbarui status di Firestore
    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(book.title)
          .update({'status': 'finished'}); // Tambahkan field status
      debugPrint("✅ Book ${book.title} ditandai selesai di Firestore.");
    } catch (e) {
      debugPrint("❌ Gagal menandai buku selesai di Firestore: $e");
    }
  }

  /// Hapus buku dari "Finished Books" atau kembalikan ke To-Read List
  void unmarkAsFinished(Book book) async {
    _finishedBooks.removeWhere((b) => b.title == book.title);
    // Kembalikan ke to-read list jika belum ada
    final toReadBook = Book(
      title: book.title,
      author: book.author,
      imageUrl: book.imageUrl,
      synopsis: book.synopsis,
      info: book.info,
      rating: null, // Reset rating dan review saat dikembalikan ke to-read
      reviewText: null,
    );

    if (!_toReadListBooks.any((b) => b.title == book.title)) {
      _toReadListBooks.add(toReadBook);
    }
    notifyListeners();

    // Perbarui status di Firestore
    try {
      await FirebaseFirestore.instance
          .collection('books')
          .doc(book.title)
          .update({'status': 'to-read', 'rating': null, 'reviewText': null}); // Update status
      debugPrint("✅ Book ${book.title} dikembalikan ke to-read di Firestore.");
    } catch (e) {
      debugPrint("❌ Gagal mengembalikan buku ke to-read di Firestore: $e");
    }
  }

  void addReview(Book book, int rating, String reviewText) async {
    // Cari buku di _finishedBooks
    int index = _finishedBooks.indexWhere((b) => b.title == book.title);
    if (index != -1) {
      // Buat instance baru dengan rating dan review yang diupdate
      final updatedBook = Book(
        title: book.title,
        author: book.author,
        imageUrl: book.imageUrl,
        synopsis: book.synopsis,
        info: book.info,
        rating: rating,
        reviewText: reviewText,
      );
      _finishedBooks[index] = updatedBook; // Ganti objek lama dengan yang baru
      notifyListeners();

      // Simpan perubahan review ke Firestore
      try {
        await FirebaseFirestore.instance
            .collection('books')
            .doc(book.title)
            .update({
          'rating': rating,
          'reviewText': reviewText,
        });
        debugPrint("✅ Review untuk ${book.title} berhasil disimpan ke Firestore.");
      } catch (e) {
        debugPrint("❌ Gagal menyimpan review ke Firestore: $e");
      }
    }
  }

  ///Ambil data dari Firestore ke `toReadListBooks` dan `finishedBooks`
  Future<void> fetchBooksFromFirebase() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('books').get();
      _toReadListBooks.clear();
      _finishedBooks.clear(); // Bersihkan juga finishedBooks
      for (var doc in snapshot.docs) {
        final book = Book.fromMap(doc.data());
        // Bedakan buku berdasarkan status
        if (doc.data()['status'] == 'finished') {
          _finishedBooks.add(book);
        } else {
          _toReadListBooks.add(book);
        }
      }
      notifyListeners();
      debugPrint("✅ Data buku berhasil diambil dari Firebase.");
    } catch (e) {
      debugPrint("❌ Gagal mengambil data dari Firebase: $e");
    }
  }
}