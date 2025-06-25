import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartlib/features/profile/screens/profile_screen.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, _) {
        final favoriteBooks = bookProvider.favoriteBooks;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            automaticallyImplyLeading: false,
            title: Text(
              'Buku Favorit',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryBlue,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person, color: AppColors.primaryBlue),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                  );
                },
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: favoriteBooks.isEmpty
                  ? const Center(
                      child: Text(
                        'Anda belum punya buku favorit.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      itemCount: favoriteBooks.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        final book = favoriteBooks[index];
                        return BookCard(book: book);
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}
