import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/models/user_model.dart';
import 'package:smartlib/common/providers/profile_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Buat controller untuk setiap field
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _genderController;

  @override
  void initState() {
    super.initState();
    // Ambil data user saat ini dari provider
    final user = Provider.of<ProfileProvider>(context, listen: false).user;

    // Inisialisasi controller dengan data yang ada
    _nameController = TextEditingController(text: user.name);
    _usernameController = TextEditingController(text: user.username);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _genderController = TextEditingController(text: user.gender);
  }

  @override
  void dispose() {
    // Jangan lupa dispose semua controller
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder())),
              const SizedBox(height: 30),
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextFormField(controller: _genderController, decoration: const InputDecoration(labelText: 'Gender', border: OutlineInputBorder())),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Discard')),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                // --- Logika Tombol Save ---
                onPressed: () {
                  // Buat objek User baru dari data di controller
                  final updatedUser = User(
                    name: _nameController.text,
                    username: _usernameController.text,
                    email: _emailController.text,
                    phoneNumber: _phoneController.text,
                    gender: _genderController.text,
                  );
                  // Panggil fungsi update dari provider
                  Provider.of<ProfileProvider>(context, listen: false).updateUserProfile(updatedUser);
                  // Kembali ke halaman profil
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}