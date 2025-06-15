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

// Tambahan untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'synopsis': synopsis,
      'info': info,
      'rating': rating,
      'reviewText': reviewText,
    };
  }

  // Tambahan untuk mengambil dari Firestore
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      synopsis: map['synopsis'] ?? '',
      info: map['info'] ?? '',
      rating: map['rating'],
      reviewText: map['reviewText'],
    );
  }
}

