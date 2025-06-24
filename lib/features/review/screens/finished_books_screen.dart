import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/review/screens/write_review_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class FinishedBooksScreen extends StatelessWidget {
  const FinishedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final finishedBooks = bookProvider.finishedBooks;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              'Buku Selesai Dibaca',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 2,
            automaticallyImplyLeading: false,
            foregroundColor: AppColors.primaryBlue,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: finishedBooks.isEmpty
                ? const Center(
                    child: Text('Anda belum menyelesaikan buku apapun.'),
                  )
                : ListView.builder(
                    itemCount: finishedBooks.length,
                    itemBuilder: (context, index) {
                      final book = finishedBooks[index];

                      Widget imageWidget;
                      if (book.imageUrl.isEmpty) {
                        imageWidget = Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.book_outlined, color: Colors.grey, size: 50),
                        );
                      } else if (book.imageUrl.startsWith('http')) {
                        imageWidget = Image.network(book.imageUrl, width: 80, height: 120, fit: BoxFit.cover);
                      } else {
                        imageWidget = Image.asset(book.imageUrl, width: 80, height: 120, fit: BoxFit.cover);
                      }

                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: imageWidget,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          book.author,
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => WriteReviewScreen(book: book),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: book.reviewText == null
                                                ? AppColors.primaryBlue
                                                : Colors.green,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: Text(
                                            book.reviewText == null ? 'Tulis Ulasan' : 'Lihat Ulasan',
                                            style: const TextStyle(color: Colors.white, fontSize: 14),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => bookProvider.unmarkAsFinished(book),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.withOpacity(0.9),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
