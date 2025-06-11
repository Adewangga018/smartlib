class Book {
  final String title;
  final String author;
  final String imageUrl;
  // --- PERUBAHAN DI SINI ---
  final String synopsis;
  final String info; // Info seperti penerbit, halaman, tahun terbit
  int? rating;
  String? reviewText;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    // Tambahkan properti baru ke constructor
    required this.synopsis,
    required this.info,
    this.rating,
    this.reviewText,
  });
}

