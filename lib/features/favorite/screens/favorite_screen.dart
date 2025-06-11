import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final favoriteBooks = bookProvider.favoriteBooks;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Buku Favorit', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.darkBlueText,
            // --- PERUBAHAN DI SINI ---
            automaticallyImplyLeading: false, // Menghilangkan tombol kembali
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: favoriteBooks.isEmpty
                ? const Center(
                    child: Text('Anda belum punya buku favorit.'),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: favoriteBooks.length,
                    itemBuilder: (context, index) {
                      final book = favoriteBooks[index];
                      return BookCard(book: book);
                    },
                  ),
          ),
        );
      },
    );
  }
}