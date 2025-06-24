import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';

class WriteReviewScreen extends StatefulWidget {
  final Book book;
  const WriteReviewScreen({super.key, required this.book});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 0;
  final _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rating = widget.book.rating ?? 0;
    _reviewController.text = widget.book.reviewText ?? '';
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;
    if (widget.book.imageUrl.isEmpty) {
      imageWidget = Container(
        width: 60,
        height: 90,
        color: Colors.grey[300],
        child: const Icon(Icons.book_outlined, color: Colors.grey, size: 40),
      );
    } else if (widget.book.imageUrl.startsWith('http')) {
      imageWidget = Image.network(widget.book.imageUrl, width: 60, height: 90, fit: BoxFit.cover);
    } else {
      imageWidget = Image.asset(widget.book.imageUrl, width: 60, height: 90, fit: BoxFit.cover);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Buku'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageWidget,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.book.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text('Nilai Produk', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 35,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // --- BAGIAN INI DIHAPUS ---
            // const Text('Tambahkan Foto', style: TextStyle(fontWeight: FontWeight.bold)),
            // const SizedBox(height: 8),
            // Container(
            //   height: 100,
            //   width: 100,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.grey),
            //   ),
            //   child: const Center(child: Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey)),
            // ),
            // const SizedBox(height: 24),
            // --- AKHIR BAGIAN YANG DIHAPUS ---

            const Text('Ulasan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _reviewController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Ketik ulasan Anda di sini...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          Provider.of<BookProvider>(context, listen: false)
              .addReview(widget.book, _rating, _reviewController.text);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.book.reviewText == null
                  ? '✅ Ulasan berhasil dikirim!'
                  : '✅ Ulasan berhasil diperbarui!',
              ),
              duration: const Duration(seconds: 2),
            ),
          );

          Navigator.of(context).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          widget.book.reviewText == null ? 'Kirim' : 'Perbarui Ulasan',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    ),
    );
  }
}