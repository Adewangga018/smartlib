import 'package:flutter/material.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/widgets/book_card.dart';
import 'package:smartlib/features/profile/screens/profile_screen.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book> dummyBooks = [
      Book(
        title: 'Bumi',
        author: 'Tere Liye',
        imageUrl: 'assets/images/bumi.jpg',
        synopsis: 'Kisah ini tentang Raib, seorang gadis berusia 15 tahun yang sama seperti remaja lainnya. Namun, ada satu rahasia yang ia simpan sendiri sejak kecil: Ia bisa menghilang. Dengan bantuan teman-temannya, Seli dan Ali, Raib berpetualang ke dunia paralel yang tidak pernah ia duga keberadaannya.',
        info: '• Penerbit: Gramedia Pustaka Utama\n• Halaman: 440\n• Terbit: Januari 2014',
      ),
      Book(
        title: 'Rembulan Tenggelam di Wajahmu',
        author: 'Tere Liye',
        imageUrl: 'assets/images/rembulan.jpg',
        synopsis: 'Kisah tentang Rehan, seorang pria 60 tahun yang terbaring di rumah sakit. Saat ia mempertanyakan hidupnya, datanglah seseorang dengan wajah teduh yang mengajukan lima pertanyaan. Pertanyaan-pertanyaan ini membawanya kembali menelusuri potongan-potongan hidupnya yang penuh makna.',
        info: '• Penerbit: Republika Penerbit\n• Halaman: 424\n• Terbit: 2006',
      ),
      Book(
        title: 'Hujan',
        author: 'Tere Liye',
        imageUrl: 'assets/images/hujan.jpg',
        synopsis: 'Ini bukan tentang cinta biasa, ini tentang persahabatan, melupakan, dan hujan. Lail, seorang gadis yang menjadi yatim piatu akibat bencana alam, harus menjalani hidup di dunia yang super canggih. Di tengah perjalanannya, ia bertemu Esok, anak laki-laki jenius yang menjadi teman spesialnya.',
        info: '• Penerbit: Gramedia Pustaka Utama\n• Halaman: 320\n• Terbit: Januari 2016',
      ),
      Book(
        title: 'Negeri Para Bedebah',
        author: 'Tere Liye',
        imageUrl: 'assets/images/negeri.jpg',
        synopsis: 'Sebuah novel action-financial thriller tentang Thomas, seorang konsultan keuangan yang sangat cerdas. Ketika sebuah bank besar di ambang kehancuran, Thomas harus berpacu dengan waktu untuk menyelamatkannya, membongkar konspirasi besar yang melibatkan orang-orang paling berkuasa.',
        info: '• Penerbit: Gramedia Pustaka Utama\n• Halaman: 440\n• Terbit: 2012',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Katalog', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.darkBlueText,
        // --- PERUBAHAN DI SINI ---
        automaticallyImplyLeading: false, // Menghilangkan tombol kembali
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, size: 30),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.filter_list, color: AppColors.darkBlueText),
                const SizedBox(width: 8),
                const Text('Filter', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: dummyBooks.length,
                itemBuilder: (context, index) {
                  final book = dummyBooks[index];
                  return BookCard(book: book);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}