import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';

class AddReadListScreen extends StatefulWidget {
  const AddReadListScreen({super.key});

  @override
  State<AddReadListScreen> createState() => _AddReadListScreenState();
}

class _AddReadListScreenState extends State<AddReadListScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Add Read-List'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cover Book', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            // --- PERUBAHAN DI SINI ---
            // Ganti placeholder teks dengan ikon
            InkWell(
              onTap: () {
                // Nanti bisa ditambahkan fungsi untuk memilih gambar
                print('Add cover tapped!');
              },
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_a_photo_outlined, // Ikon untuk menambah foto
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // --- AKHIR PERUBAHAN ---
            const SizedBox(height: 24),
            const Text('Book Information', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Discard'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final title = _titleController.text;
                  final author = _authorController.text;

                  if (title.isNotEmpty && author.isNotEmpty) {
                    final newBook = Book(
                      title: title,
                      author: author,
                      imageUrl: '',
                      synopsis: '',
                      info: '',
                    );
                    Provider.of<BookProvider>(context, listen: false).addToReadList(newBook);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Judul dan Penulis tidak boleh kosong!'), duration: Duration(seconds: 2)),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}