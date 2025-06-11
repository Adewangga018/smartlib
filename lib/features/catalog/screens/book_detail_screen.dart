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
        final isFav = bookProvider.isFavorite(book);
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
                  onPressed: () => bookProvider.toggleFavorite(book),
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
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.network(book.imageUrl, fit: BoxFit.cover)),
                  ),
                  const SizedBox(height: 20),
                  Text(book.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkBlueText)),
                  const SizedBox(height: 8),
                  Text(book.author, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),
                  const TabBar(
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: AppColors.primaryBlue,
                    tabs: [Tab(text: 'Synopsis'), Tab(text: 'Info'), Tab(text: 'Reviews')],
                  ),
                  SizedBox(
                    height: 200,
                    child: TabBarView(
                      children: [
                        // --- PERUBAHAN DI SINI ---
                        _buildSynopsisTab(book),
                        _buildInfoTab(book),
                        _buildReviewsTab(context, book)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  bookProvider.addToReadList(book);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ditambahkan ke To-read List'), duration: Duration(seconds: 1)));
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('+ Add to Read-List', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- PERUBAHAN DI SINI: Menampilkan sinopsis dari objek Book ---
  Widget _buildSynopsisTab(Book book) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        book.synopsis, // Menggunakan data sinopsis dinamis
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[700],
          height: 1.5,
        ),
      ),
    );
  }

  // --- PERUBAHAN DI SINI: Menampilkan info dari objek Book ---
  Widget _buildInfoTab(Book book) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        book.info, // Menggunakan data info dinamis
        style: TextStyle(
          fontSize: 15,
          color: Colors.grey[800],
          height: 1.8,
        ),
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, Book book) {
    final bookData = Provider.of<BookProvider>(context).finishedBooks.firstWhere(
          (b) => b.title == book.title,
          orElse: () => book,
        );

    if (bookData.rating == null || bookData.rating == 0) {
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
                  index < bookData.rating! ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                )),
              )
            ],
          ),
          const SizedBox(height: 16),
          const Text('Ulasan:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(bookData.reviewText ?? 'Tidak ada teks ulasan.'),
        ],
      ),
    );
  }
}