import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        final currentBook = bookProvider.toReadListBooks.firstWhere(
          (b) => b.title == book.title,
          orElse: () => bookProvider.finishedBooks.firstWhere(
            (b) => b.title == book.title,
            orElse: () => book,
          ),
        );

        final isFav = bookProvider.isFavorite(currentBook);

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            backgroundColor: const Color(0xFFF1F6FD),
            appBar: AppBar(
              title: Text(
                'Detail Buku',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: const IconThemeData(color: AppColors.primaryBlue),
              actions: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                  ),
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
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: currentBook.imageUrl.isNotEmpty
                          ? Image.network(
                              currentBook.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _errorImage(),
                            )
                          : _errorImage(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    currentBook.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkBlueText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${currentBook.author}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  TabBar(
                    indicatorColor: AppColors.primaryBlue,
                    labelColor: AppColors.primaryBlue,
                    unselectedLabelColor: Colors.grey[500],
                    labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    tabs: const [
                      Tab(text: 'Sinopsis'),
                      Tab(text: 'Info Buku'),
                      Tab(text: 'Ulasan'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TabBarView(
                      children: [
                        _buildSynopsisTab(context, currentBook),
                        _buildInfoTab(context, currentBook),
                        _buildReviewsTab(context, currentBook),
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

  Widget _errorImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.broken_image, color: Colors.grey, size: 80),
      ),
    );
  }

  Widget _buildSynopsisTab(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        book.synopsis.isNotEmpty ? book.synopsis : 'Sinopsis belum tersedia.',
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildInfoTab(BuildContext context, Book book) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        book.info.isNotEmpty ? book.info : 'Informasi buku belum tersedia.',
        style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[800], height: 1.8),
      ),
    );
  }

  Widget _buildReviewsTab(BuildContext context, Book book) {
    if (book.rating == null || book.rating == 0) {
      return Center(
        child: Text(
          'Belum ada ulasan untuk buku ini.',
          style: GoogleFonts.poppins(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Rating:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < book.rating! ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 16),
          Text('Ulasan:', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            book.reviewText ?? 'Tidak ada ulasan.',
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[800]),
          ),
        ],
      ),
    );
  }
}
