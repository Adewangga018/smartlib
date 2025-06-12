import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/core/services/auth_service.dart';
import 'package:smartlib/core/providers/auth_provider.dart';
import 'package:smartlib/common/providers/profile_provider.dart';
import 'package:smartlib/landing_page.dart';
import 'package:smartlib/firestore_service.dart'; // Import FirestoreService yang sudah dimodifikasi

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi AuthService dan FirestoreService di sini
    // Karena mereka adalah singletons yang akan digunakan oleh providers lain
    final authService = AuthService();
    final firestoreService = FirestoreService(); // Inisialisasi FirestoreService

    return MultiProvider(
      providers: [
        // Sediakan AuthService sebagai Provider
        Provider<AuthService>(
          create: (_) => authService,
        ),
        // Sediakan FirestoreService sebagai Provider
        Provider<FirestoreService>( // Sediakan FirestoreService agar dapat diakses oleh ProfileProvider
          create: (_) => firestoreService,
        ),
        // Sediakan AuthProvider yang bergantung pada AuthService
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(), // Mengambil AuthService dari Provider di atasnya
          ),
        ),
        // Sediakan BookProvider (sesuai yang sudah ada)
        ChangeNotifierProvider<BookProvider>(
          create: (context) => BookProvider(),
        ),
        // Sediakan ProfileProvider yang bergantung pada FirestoreService
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(
            context.read<FirestoreService>(), // Mengambil FirestoreService dari Provider di atasnya
          ),
        ),
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
  }
}