import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:smartlib/features/profile/screens/profile_screen.dart';
import 'package:smartlib/features/catalog/screens/book_detail_screen.dart';


class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  int? selectedRating;
  String searchQuery = '';


  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final Map<String, Book> bookMap = {
          for (var b in bookProvider.finishedBooks) b.title: b,
          for (var b in bookProvider.toReadListBooks) b.title: b,
          for (var b in bookProvider.defaultCatalogBooks) b.title: b,
        };
        final uniqueBooks = bookMap.values.toList();

        final filteredBooks = uniqueBooks.where((book) {
        final matchesRating = selectedRating == null || (book.rating ?? 0) == selectedRating;
        final matchesSearch = book.title.toLowerCase().contains(searchQuery) ||
                              book.author.toLowerCase().contains(searchQuery);
        return matchesRating && matchesSearch;
      }).toList();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            automaticallyImplyLeading: false,
            title: Text(
              'Katalog Buku',
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
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari judul atau penulis...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: GoogleFonts.poppins(fontSize: 14),
                ),
                const SizedBox(height: 16),
                // Filter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //searchbar
                    Text(
                      'Filter Rating',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryBlue),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int?>(
                          value: selectedRating,
                          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryBlue),
                          onChanged: (value) {
                            setState(() {
                              selectedRating = value;
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
                const SizedBox(height: 20),
                const Divider(thickness: 1.2),
                const SizedBox(height: 8),

                // Section title
                const SizedBox(height: 12),
                // Grid
                Expanded(
                  child: filteredBooks.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.menu_book_outlined, size: 60, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(
                              'Buku tidak ditemukan',
                              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        )
                      : GridView.builder(
                          itemCount: filteredBooks.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final book = filteredBooks[index];
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailScreen(book: book),
                                      ),
                                    );
                                  },
                                  child: BookCard(book: book),
                                ),
                              ),
                            );
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
