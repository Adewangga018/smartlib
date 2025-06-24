import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/theme/app_colors.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Buku
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: book.imageUrl.isNotEmpty
                  ? Image.network(
                      book.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _fallbackImage(),
                    )
                  : _fallbackImage(),
            ),
          ),

          // Informasi Buku
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlueText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 12.5,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  if ((book.rating ?? 0) > 0)
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < (book.rating ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.book, color: Colors.grey, size: 60),
      ),
    );
  }
}
