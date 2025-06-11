import 'package:flutter/material.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    // --- PERUBAHAN DI SINI: Tambah kondisi untuk URL kosong ---
    if (book.imageUrl.isEmpty) {
      // Jika URL kosong, tampilkan ikon placeholder
      imageWidget = const Center(child: Icon(Icons.book_outlined, color: Colors.grey, size: 80));
    } else if (book.imageUrl.startsWith('http')) {
      // Jika link web, gunakan Image.network
      imageWidget = Image.network(
        book.imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.book, color: Colors.grey, size: 50));
        },
      );
    } else {
      // Jika bukan, anggap itu aset lokal dan gunakan Image.asset
      imageWidget = Image.asset(
        book.imageUrl,
        fit: BoxFit.cover,
      );
    }
    // --- AKHIR PERUBAHAN ---

    return GestureDetector(
      onTap: () {
        // Jangan buka detail jika buku tidak punya sinopsis (buku manual)
        if (book.synopsis.isNotEmpty) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BookDetailScreen(book: book),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Beri warna dasar untuk placeholder
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageWidget,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.darkBlueText,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}