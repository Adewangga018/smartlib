import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddReadListScreen extends StatefulWidget {
  const AddReadListScreen({super.key});

  @override
  State<AddReadListScreen> createState() => _AddReadListScreenState();
}

class _AddReadListScreenState extends State<AddReadListScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = _imageUrlController.text.trim();

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
            GestureDetector(
              onTap: () {
                _showImageLinkDialog(context);
              },
              child: Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Text('❌ Gagal memuat gambar'));
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.add_a_photo_outlined, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Book Information', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
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
                onPressed: _saveBook,
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

  void _saveBook() async {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (title.isEmpty || author.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan Penulis tidak boleh kosong!')),
      );
      return;
    }

    final newBook = Book(
      title: title,
      author: author,
      imageUrl: imageUrl,
      synopsis: '',
      info: '',
    );

    Provider.of<BookProvider>(context, listen: false).addToReadList(newBook);

    try {
      await _saveBookToFirestore(newBook);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Buku berhasil disimpan ke Firebase!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan ke Firebase: $e')),
        );
      }
    }

    Navigator.of(context).pop();
  }

  Future<void> _saveBookToFirestore(Book book) async {
    await FirebaseFirestore.instance.collection('books').add({
      'title': book.title,
      'author': book.author,
      'imageUrl': book.imageUrl,
      'synopsis': book.synopsis,
      'info': book.info,
      'rating': book.rating,
      'reviewText': book.reviewText,
      'createdAt': Timestamp.now(),
    });
    debugPrint("✅ Book berhasil disimpan ke Firestore: ${book.title}");
  }

  void _showImageLinkDialog(BuildContext context) {
    final tempController = TextEditingController(text: _imageUrlController.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambahkan Link Gambar'),
        content: TextField(
          controller: tempController,
          decoration: const InputDecoration(
            hintText: 'Paste link gambar di sini...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _imageUrlController.text = tempController.text.trim();
              });
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
