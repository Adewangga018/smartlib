import 'package:flutter/material.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/auth/screens/login_screen.dart';
import 'package:smartlib/features/auth/screens/signup_screen.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo besar di tengah
              Image.asset(
                'assets/images/logo.png',
                height: 200,
              ),
              const SizedBox(height: 40),
              
              // Judul aplikasi
              const Text(
                'SmartLib',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlueText,
                ),
              ),
              const SizedBox(height: 8),
              
              // Tagline
              const Text(
                'Your Smart Library Solution',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.lightBlueText,
                ),
              ),
              const SizedBox(height: 40),
              
              // Deskripsi fitur
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Akses ribuan buku digital, manajemen peminjaman, dan fitur canggih lainnya dalam genggaman Anda',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              
              // Tombol Login
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Tombol Register
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.primaryBlue),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}