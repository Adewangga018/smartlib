import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:google_fonts/google_fonts.dart';

class AddFromCatalogScreen extends StatelessWidget {
  const AddFromCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        // Buat map unik berdasarkan title (hindari duplikasi)
        final Map<String, Book> bookMap = {
          for (var b in bookProvider.defaultCatalogBooks) b.title: b,
        };

        final List<Book> uniqueCatalogBooks = bookMap.values.toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            title: Text(
              'Tambah dari Katalog',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            foregroundColor: AppColors.primaryBlue,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: uniqueCatalogBooks.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final book = uniqueCatalogBooks[index];

                final isInToReadList = bookProvider.toReadListBooks.any((b) => b.title == book.title);
                final isInFinishedList = bookProvider.finishedBooks.any((b) => b.title == book.title);

                final alreadyAdded = isInToReadList || isInFinishedList;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BookCard(book: book),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40, // agar tombol punya tinggi konsisten
                      child: ElevatedButton(
                        onPressed: alreadyAdded
                            ? null
                            : () {
                                bookProvider.addToReadList(book);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('"${book.title}" berhasil ditambahkan ke daftar baca.'),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: alreadyAdded ? Colors.grey : AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 3,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            alreadyAdded ? 'Sudah Ditambahkan' : 'Tambah ke Daftar Baca',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
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
