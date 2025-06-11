import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:smartlib/features/to_read_list/screens/add_read_list_screen.dart';

class ToReadListScreen extends StatelessWidget {
  const ToReadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final toReadBooks = bookProvider.toReadListBooks;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('To-read List', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.darkBlueText,
            // --- PERUBAHAN DI SINI ---
            automaticallyImplyLeading: false, // Menghilangkan tombol kembali
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: toReadBooks.isEmpty
                ? const Center(
                    child: Text('Daftar baca Anda masih kosong.'),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: toReadBooks.length,
                    itemBuilder: (context, index) {
                      final book = toReadBooks[index];
                      return Column(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                BookCard(book: book),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black.withOpacity(0.6),
                                    radius: 15,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(Icons.close, color: Colors.white, size: 15),
                                      onPressed: () => bookProvider.removeFromReadList(book),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => bookProvider.markAsFinished(book),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Tandai Selesai'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddReadListScreen()),
              );
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}