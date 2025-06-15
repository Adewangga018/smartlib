import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart'; // Import BookProvider
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:smartlib/features/profile/screens/profile_screen.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int? selectedRating; // null means show all
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>( // Gunakan Consumer untuk mendengarkan perubahan pada BookProvider
      builder: (context, bookProvider, child) {
        // Gabungkan buku dari toReadListBooks dan finishedBooks
        // Pastikan tidak ada duplikasi jika buku ada di kedua list (walaupun seharusnya tidak)
        final allBooks = bookProvider.finishedBooks.where((book) => book.reviewText != null && book.reviewText!.isNotEmpty).toList();

        // Filter buku berdasarkan rating
        final filteredBooks = selectedRating == null
        ? allBooks
        : allBooks.where((book) => book.rating == selectedRating).toList();


        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text(
              'Katalog Buku',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            backgroundColor: AppColors.background,
            elevation: 0,
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    const Text(
      'Filter Rating',
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.primaryBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: selectedRating,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlue),
          onChanged: (int? newValue) {
            setState(() {
              selectedRating = newValue;
            });
          },
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Semua'),
            ),
            ...List.generate(5, (index) {
              final ratingValue = index + 1;
              return DropdownMenuItem<int?>(
                value: ratingValue,
                child: Row(
                  children: List.generate(
                    ratingValue,
                    (_) => const Icon(Icons.star, size: 16, color: Colors.orange),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    ),
  ],
),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
                const Divider(thickness: 1.2),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Daftar Buku',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: filteredBooks.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.menu_book_outlined, size: 60, color: Colors.grey),
                              SizedBox(height: 12),
                              Text(
                                'Belum ada buku dengan rating tersebut.',
                                style: TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ],
                          ),
                      )
                      : 
                      GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: BookCard(book: book),
                          );
                        }
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}