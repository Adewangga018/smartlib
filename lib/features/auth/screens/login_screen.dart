import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/core/providers/auth_provider.dart'; // Tambahkan ini
import 'package:smartlib/features/auth/screens/signup_screen.dart';
import 'package:smartlib/features/navigation/screens/main_screen.dart';

class LoginScreen extends StatefulWidget { // Ubah ke StatefulWidget
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 16),
                const Text('Login', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkBlueText)),
                const Text('SmartLib', textAlign: TextAlign.center, style: TextStyle(fontSize: 24, color: AppColors.lightBlueText, fontWeight: FontWeight.w600)),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email', 
                    hintText: 'Enter Email', 
                    border: OutlineInputBorder(), 
                    filled: true, 
                    fillColor: Colors.white
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, 
                  decoration: const InputDecoration(
                    labelText: 'Password', 
                    hintText: 'Enter Password', 
                    border: OutlineInputBorder(), 
                    filled: true, 
                    fillColor: Colors.white
                  ),
                ),
                const SizedBox(height: 30),
                if (authProvider.errorMessage != null)
                  Text(
                    authProvider.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: authProvider.isLoading 
                    ? null 
                    : () async {
                        final success = await authProvider.login(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                        if (success && mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const MainScreen()),
                          );
                        }
                      },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: authProvider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {}, 
                  child: const Text('Lupa Password?', style: TextStyle(color: AppColors.darkBlueText, fontWeight: FontWeight.bold))
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Belum punya akun?"),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpScreen()));
                      },
                      child: const Text('Sign Up', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}