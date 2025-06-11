import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/core/services/auth_service.dart'; // Tambahkan ini
import 'package:smartlib/core/providers/auth_provider.dart'; // Tambahkan ini
import 'package:smartlib/common/providers/profile_provider.dart'; // IMPORT ProfileProvider
import 'package:smartlib/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- PERUBAHAN DI SINI: Gunakan MultiProvider ---
    return MultiProvider(
      providers: [
        // Daftarkan semua provider di sini
        Provider(create: (_) => AuthService()), // Tambahkan AuthService
        ChangeNotifierProvider(create: (context) => AuthProvider(context.read<AuthService>())), // Tambahkan AuthProvider
        ChangeNotifierProvider(create: (context) => BookProvider()),
        ChangeNotifierProvider(create: (context) => ProfileProvider()),

      ],
      child: MaterialApp(
        title: 'SmartLib',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const LandingPage(),
      ),
    );
    // --- AKHIR PERUBAHAN ---
  }
}