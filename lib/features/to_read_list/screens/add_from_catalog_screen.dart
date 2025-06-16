import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';

class AddFromCatalogScreen extends StatelessWidget {
  const AddFromCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        // Ambil buku unik dari katalog
        final Map<String, Book> bookMap = {
          for (var b in bookProvider.finishedBooks) b.title: b,
          for (var b in bookProvider.toReadListBooks) b.title: b,
          for (var b in bookProvider.defaultCatalogBooks) b.title: b,
        };
        final uniqueBooks = bookMap.values.toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Tambah dari Katalog'),
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.darkBlueText,
            elevation: 0,
          ),
          backgroundColor: AppColors.background,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemCount: uniqueBooks.length,
              itemBuilder: (context, index) {
                final book = uniqueBooks[index];
                final alreadyInToRead = bookProvider.toReadListBooks.any((b) => b.title == book.title);
                return Column(
                  children: [
                    Expanded(child: BookCard(book: book)),
                    const SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: alreadyInToRead
                          ? null
                          : () {
                              bookProvider.addToReadList(book);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('"${book.title}" ditambahkan ke daftar baca!')),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: alreadyInToRead ? Colors.grey : AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(alreadyInToRead ? 'Sudah Ditambahkan' : 'Tambah ke Daftar Baca'),
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
