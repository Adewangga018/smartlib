import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/review/screens/write_review_screen.dart';

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
            title: const Text('Buku Selesai Dibaca', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
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

                      // --- PERUBAHAN DI SINI: Bungkus Card dengan Stack ---
                      return Stack(
                        children: [
                          Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
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
                                        Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text(book.author, style: const TextStyle(color: Colors.grey)),
                                        const SizedBox(height: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(builder: (context) => WriteReviewScreen(book: book)),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: book.reviewText == null ? AppColors.primaryBlue : Colors.green,
                                          ),
                                          child: Text(book.reviewText == null ? 'Tulis Ulasan' : 'Lihat Ulasan', style: const TextStyle(color: Colors.white)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Tombol Delete di pojok kanan atas
                          Positioned(
                            top: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.red.withOpacity(0.8),
                              radius: 14,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(Icons.close, color: Colors.white, size: 14),
                                onPressed: () {
                                  // Panggil fungsi unmarkAsFinished
                                  bookProvider.unmarkAsFinished(book);
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                      // --- AKHIR PERUBAHAN ---
                    },
                  ),
          ),
        );
      },
    );
  }
}