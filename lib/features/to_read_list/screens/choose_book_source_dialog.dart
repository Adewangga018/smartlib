import 'package:flutter/material.dart';

class ChooseBookSourceDialog extends StatelessWidget {
  const ChooseBookSourceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Pilih Sumber Buku'),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop('new'),
          child: const Text('Buat Buku Baru'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.of(context).pop('catalog'),
          child: const Text('Ambil dari Katalog'),
        ),
      ],
    );
  }
}
