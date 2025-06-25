// profile_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/profile_provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/auth/screens/login_screen.dart';
import 'package:smartlib/features/profile/screens/edit_profile_screen.dart';
import 'package:smartlib/core/providers/auth_provider.dart';
import 'package:smartlib/features/profile/screens/change_password_screen.dart';
import 'package:smartlib/features/profile/screens/delete_account_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Consumer<ProfileProvider>(
      builder: (context, profileProvider, child) {
        final user = profileProvider.user;

        // --- TAMBAHKAN PRINT STATEMENT DI SINI ---
        print('ProfileScreen: Rendering. Current user photoUrl: ${user?.photoUrl}');
        // ----------------------------------------

        if (profileProvider.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (profileProvider.errorMessage != null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: AppColors.background,
              elevation: 0,
              foregroundColor: AppColors.darkBlueText,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  profileProvider.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: AppColors.background,
              elevation: 0,
              foregroundColor: AppColors.darkBlueText,
            ),
            body: const Center(
              child: Text(
                'No profile data available. Please login.',
                style: TextStyle(color: AppColors.darkBlueText),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: AppColors.background,
            elevation: 0,
            foregroundColor: AppColors.darkBlueText,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0F7FA), Color(0xFFF3E5F5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                      profileProvider.reloadUserProfile();
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryBlue,
                      backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                          ? NetworkImage(user.photoUrl!) as ImageProvider<Object>?
                          : null,
                      child: user.photoUrl == null || user.photoUrl!.isEmpty
                          ? const Icon(Icons.person, size: 60, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkBlueText),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.edit_outlined, color: AppColors.darkBlueText),
                    title: const Text('Edit Profile'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                      profileProvider.reloadUserProfile();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outline, color: AppColors.darkBlueText),
                    title: const Text('Change Password'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Logout', style: TextStyle(color: Colors.red)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.red),
                    onTap: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.red),
                    title: const Text('Delete Account', style: TextStyle(color: Colors.red)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.red),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const DeleteAccountScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}