import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:smartlib/features/to_read_list/screens/add_read_list_screen.dart';
import 'package:smartlib/features/to_read_list/screens/edit_read_list_screen.dart';
import 'package:smartlib/features/to_read_list/screens/choose_book_source_dialog.dart';
import 'package:smartlib/features/to_read_list/screens/add_from_catalog_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartlib/features/profile/screens/profile_screen.dart';

class ToReadListScreen extends StatelessWidget {
  const ToReadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final toReadBooks = bookProvider.toReadListBooks;

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 2,
            automaticallyImplyLeading: false,
            title: Text(
              'Daftar Baca',
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
                // Section Title
                Row(
                  children: [
                    const Icon(Icons.menu_book, color: AppColors.primaryBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Buku yang Ingin Dibaca',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Grid/List of Books
                Expanded(
                  child: toReadBooks.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.library_books_outlined, size: 60, color: Colors.grey),
                            const SizedBox(height: 12),
                            Text(
                              'Daftar baca Anda masih kosong.',
                              style: GoogleFonts.poppins(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        )
                      : GridView.builder(
                          itemCount: toReadBooks.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.65,
                          ),
                          itemBuilder: (context, index) {
                            final book = toReadBooks[index];
                            return Stack(
                              children: [
                                // BookCard
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BookCard(book: book),
                                ),
                                // Action Buttons
                                Positioned(
                                  bottom: 8,
                                  left: 8,
                                  right: 8,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Button selesai
                                      ElevatedButton(
                                        onPressed: () => bookProvider.markAsFinished(book),
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 12),
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: const Text('Selesai', style: TextStyle(fontSize: 12)),
                                      ),
                                      // Icon edit
                                      IconButton(
                                        icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => EditReadListScreen(book: book),
                                            ),
                                          );
                                        },
                                      ),
                                      // Icon delete
                                      IconButton(
                                        icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Konfirmasi'),
                                              content: Text('Hapus "${book.title}" dari daftar baca?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await bookProvider.removeFromToReadList(book);
                                                  },
                                                  child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await showDialog<String>(
                context: context,
                builder: (context) => const ChooseBookSourceDialog(),
              );
              if (result == 'new') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddReadListScreen()),
                );
              } else if (result == 'catalog') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const AddFromCatalogScreen()),
                );
              }
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}
