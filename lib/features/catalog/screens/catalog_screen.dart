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
        final allBooks = [...bookProvider.toReadListBooks, ...bookProvider.finishedBooks];

        // Hapus duplikasi jika ada (berdasarkan title)
        final uniqueBooks = <String, Book>{};
        for (var book in allBooks) {
          uniqueBooks[book.title] = book;
        }
        final List<Book> booksToDisplay = uniqueBooks.values.toList();


        // Filter buku berdasarkan rating
        final filteredBooks = selectedRating == null
            ? booksToDisplay // Gunakan data dari provider
            : booksToDisplay.where((book) => book.rating == selectedRating).toList();

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
                      'Filter berdasarkan Rating:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    DropdownButton<int?>(
                      value: selectedRating,
                      onChanged: (int? newValue) {
                        setState(() {
                          selectedRating = newValue;
                        });
                      },
                      hint: const Text('Pilih Rating'),
                      icon: const Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: const SizedBox(),
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
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: filteredBooks.isEmpty
                      ? const Center(
                          child: Text('Tidak ada buku di katalog ini.'),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return BookCard(book: book);
                          },
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