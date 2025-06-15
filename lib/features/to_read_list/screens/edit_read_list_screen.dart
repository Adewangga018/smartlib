import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/book_model.dart';
import 'package:smartlib/common/providers/book_provider.dart';

class EditReadListScreen extends StatefulWidget {
  final Book book;
  const EditReadListScreen({super.key, required this.book});

  @override
  State<EditReadListScreen> createState() => _EditReadListScreenState();
}

class _EditReadListScreenState extends State<EditReadListScreen> {
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _imageUrlController;
  late TextEditingController _synopsisController;
  late TextEditingController _infoController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.book.title);
    _authorController = TextEditingController(text: widget.book.author);
    _imageUrlController = TextEditingController(text: widget.book.imageUrl);
    _synopsisController = TextEditingController(text: widget.book.synopsis);
    _infoController = TextEditingController(text: widget.book.info);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _imageUrlController.dispose();
    _synopsisController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  void _saveEdit() async {
    final updatedBook = Book(
      title: _titleController.text,
      author: _authorController.text,
      imageUrl: _imageUrlController.text,
      synopsis: _synopsisController.text,
      info: _infoController.text,
      status: widget.book.status,
      rating: widget.book.rating,
      reviewText: widget.book.reviewText,
    );
    await Provider.of<BookProvider>(context, listen: false)
        .updateToReadBook(widget.book, updatedBook);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Buku')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'Judul')),
            TextField(controller: _authorController, decoration: const InputDecoration(labelText: 'Penulis')),
            TextField(controller: _imageUrlController, decoration: const InputDecoration(labelText: 'URL Gambar')),
            TextField(controller: _synopsisController, decoration: const InputDecoration(labelText: 'Sinopsis')),
            TextField(controller: _infoController, decoration: const InputDecoration(labelText: 'Info Lain')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEdit,
              child: const Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
