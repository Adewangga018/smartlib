import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';

class BookDetailScreen extends StatelessWidget {
  final Book book;
  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        // Ambil data buku dari provider untuk memastikan kita mendapatkan data terbaru
        // Termasuk rating dan review jika sudah di-fetch.
        // Kita cari di toReadList dan finishedBooks.
        final currentBook = bookProvider.toReadListBooks.firstWhere(
              (b) => b.title == book.title,
              orElse: () => bookProvider.finishedBooks.firstWhere(
                    (b) => b.title == book.title,
                    orElse: () => book, // Fallback ke buku asli jika tidak ditemukan di provider
                  ),
            );

        final isFav = bookProvider.isFavorite(currentBook);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Details'),
              backgroundColor: AppColors.background,
              actions: [
                IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                  onPressed: () => bookProvider.toggleFavorite(currentBook),
                )
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 300,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: currentBook.imageUrl.isNotEmpty
                          ? Image.network(
                              currentBook.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Center(
                                  child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.book_outlined, color: Colors.grey, size: 80),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    currentBook.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBlueText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${currentBook.author}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const TabBar(
                    indicatorColor: AppColors.primaryBlue,
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Sinopsis'),
                      Tab(text: 'Info Buku'),
                      Tab(text: 'Ulasan'),
                    ],
                  ),
                  SizedBox(
                    height: 300, // Atur tinggi sesuai kebutuhan
                    child: TabBarView(
                      children: [
                        _buildSynopsisTab(context, currentBook), // Menggunakan currentBook
                        _buildInfoTab(context, currentBook),     // Menggunakan currentBook
                        _buildReviewsTab(context, currentBook),  // Menggunakan currentBook
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSynopsisTab(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        book.synopsis.isNotEmpty ? book.synopsis : 'Sinopsis belum tersedia.', // Tampilkan sinopsis
        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        book.info.isNotEmpty ? book.info : 'Informasi buku belum tersedia.', // Tampilkan info
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, Book book) {
    // Kita sudah mengambil `currentBook` di bagian build, jadi kita bisa langsung menggunakannya.
    // Tidak perlu mencari lagi di finishedBooks.
    if (book.rating == null || book.rating == 0) {
      return const Center(child: Text('Belum ada ulasan untuk buku ini.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('Rating:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Row(
                children: List.generate(5, (index) => Icon(
                  index < book.rating! ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                )),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text('Ulasan:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            book.reviewText ?? 'Tidak ada ulasan.',
            style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}