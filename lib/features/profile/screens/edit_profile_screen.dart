// edit_profile_screen.dart
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
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _photoUrlController; // TAMBAHAN: Controller untuk photoUrl

  String? _userId;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<ProfileProvider>(context, listen: false).user;

    if (user != null) {
      _userId = user.id;
      _firstNameController = TextEditingController(text: user.firstName);
      _lastNameController = TextEditingController(text: user.lastName);
      _usernameController = TextEditingController(text: user.username);
      _emailController = TextEditingController(text: user.email);
      _phoneController = TextEditingController(text: user.phoneNumber);
      _photoUrlController = TextEditingController(text: user.photoUrl); // TAMBAHAN: Inisialisasi photoUrl
    } else {
      _userId = '';
      _firstNameController = TextEditingController();
      _lastNameController = TextEditingController();
      _usernameController = TextEditingController();
      _emailController = TextEditingController();
      _phoneController = TextEditingController();
      _photoUrlController = TextEditingController(); // TAMBAHAN: Inisialisasi kosong
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: No user data to edit.')),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _photoUrlController.dispose(); // TAMBAHAN: Dispose controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: AppColors.background,
      ),
      body: profileProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center( // TAMBAHAN: Tampilkan CircleAvatar untuk foto profil
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Implementasi logic untuk memilih/mengubah foto
                          // Saat ini hanya fokus pada input link
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Masukkan link foto di bawah.')),
                          );
                        },
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: AppColors.primaryBlue,
                          backgroundImage: _photoUrlController.text.isNotEmpty
                              ? NetworkImage(_photoUrlController.text) as ImageProvider<Object>?
                              : null,
                          child: _photoUrlController.text.isEmpty
                              ? const Icon(Icons.camera_alt, size: 60, color: Colors.white)
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField( // TAMBAHAN: Field untuk Photo URL
                      controller: _photoUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Profile Photo URL (Link)',
                        hintText: 'e.g. https://i.imgur.com/C9KjwLE.jpeg',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text('Profile Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(controller: _firstNameController, decoration: const InputDecoration(labelText: 'First Name', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    TextFormField(controller: _lastNameController, decoration: const InputDecoration(labelText: 'Last Name', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    TextFormField(controller: _usernameController, decoration: const InputDecoration(labelText: 'Username', border: OutlineInputBorder())),
                    const SizedBox(height: 30),
                    const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
                        readOnly: true,
                        style: const TextStyle(color: Colors.grey)
                    ),
                    const SizedBox(height: 16),
                    TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder())),
                    const SizedBox(height: 16),
                    if (profileProvider.errorMessage != null)
                      Text(
                        profileProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
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
                onPressed: profileProvider.isLoading || _userId == null || _userId!.isEmpty
                    ? null
                    : () async {
                        // Buat objek User baru dari data di controller
                        final updatedUser = User(
                          id: _userId!,
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          username: _usernameController.text,
                          email: _emailController.text,
                          phoneNumber: _phoneController.text,
                          photoUrl: _photoUrlController.text.isNotEmpty ? _photoUrlController.text : null, // TAMBAHAN: Ambil photoUrl dari controller
                        );
                        // Panggil fungsi update dari provider
                        await profileProvider.updateUserProfile(updatedUser);

                        // Panggil update photo secara terpisah jika diperlukan (opsional, karena sudah terintegrasi di updateUserProfile)
                        // await profileProvider.updateProfilePhoto(_photoUrlController.text.isNotEmpty ? _photoUrlController.text : null);

                        if (context.mounted && profileProvider.errorMessage == null) {
                          Navigator.of(context).pop();
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: Colors.white),
                child: profileProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}