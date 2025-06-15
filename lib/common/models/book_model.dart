class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String status;

  // --- PERUBAHAN DI SINI ---
  final String synopsis; // Properti baru untuk sinopsis
  final String info;     // Properti baru untuk info buku (penerbit, halaman, dll)
  int? rating;
  String? reviewText;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.status, // status
    // Tambahkan properti baru ke constructor
    required this.synopsis, // Wajib diisi
    required this.info,     // Wajib diisi
    this.rating,
    this.reviewText,
  });

// Tambahan untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'synopsis': synopsis,   // Tambahkan ke map
      'info': info,           // Tambahkan ke map
      'rating': rating,
      'reviewText': reviewText,
      'status': status, // pastikan disimpan ke Firestore
    };
  }

  // Tambahan untuk mengambil dari Firestore
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      synopsis: map['synopsis'] ?? '', // Ambil dari map
      info: map['info'] ?? '',         // Ambil dari map
      rating: map['rating'],
      reviewText: map['reviewText'],
      status: map['status'] ?? 'to_read', // default jika tidak ada status
    );
  }
}