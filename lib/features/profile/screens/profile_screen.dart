import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/profile_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/auth/screens/signup_screen.dart'; // IMPORT halaman signup
import 'package:smartlib/features/profile/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = profileProvider.user;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.darkBlueText,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primaryBlue,
                      child: Icon(Icons.person, size: 50, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkBlueText),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: AppColors.darkBlueText),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.darkBlueText),
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                // --- PERUBAHAN DI SINI ---
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text('Logout', style: TextStyle(color: Colors.red)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.red),
                  onTap: () {
                    // Aksi Logout: Kembali ke halaman awal dan hapus semua halaman sebelumnya
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                      (Route<dynamic> route) => false, // Predikat ini menghapus semua route
                    );
                  },
                ),
                // --- AKHIR PERUBAHAN ---
              ],
            ),
          ),
        );
      },
    );
  }
}