import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:smartlib/features/to_read_list/screens/add_read_list_screen.dart';
import 'package:smartlib/features/to_read_list/screens/edit_read_list_screen.dart';
import 'package:smartlib/features/to_read_list/screens/choose_book_source_dialog.dart';
import 'package:smartlib/features/to_read_list/screens/add_from_catalog_screen.dart';

class ToReadListScreen extends StatelessWidget {
  const ToReadListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        // Ambil buku dari toReadListBooks
        final toReadBooks = bookProvider.toReadListBooks;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('To-read List', style: TextStyle(fontWeight: FontWeight.bold)),
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.darkBlueText,
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
                      childAspectRatio: 0.65,
                    ),
                    itemCount: toReadBooks.length,
                    itemBuilder: (context, index) {
                      final book = toReadBooks[index];
                      return Column(
                        children: [
                          Expanded(child: BookCard(book: book)),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => bookProvider.markAsFinished(book),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  child: const Text('Selesai'),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => EditReadListScreen(book: book),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: Text('Apakah Anda yakin ingin menghapus "${book.title}" dari daftar baca?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context), // Batal
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context); // Tutup dialog dulu
                                            await bookProvider.removeFromToReadList(book); // Hapus buku
                                          },
                                          child: const Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    },
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