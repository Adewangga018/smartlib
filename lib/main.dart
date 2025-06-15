// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:smartlib/common/providers/book_provider.dart';
import 'package:smartlib/core/services/auth_service.dart';
import 'package:smartlib/core/providers/auth_provider.dart';
import 'package:smartlib/common/providers/profile_provider.dart';
import 'package:smartlib/landing_page.dart';
import 'package:smartlib/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // <-- Import ini

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
    final authService = AuthService();
    final firestoreService = FirestoreService();

    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => authService,
        ),
        Provider<FirestoreService>(
          create: (_) => firestoreService,
        ),
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
            context.read<AuthService>(),
          ),
        ),
        // --- PERUBAHAN DI SINI: BookProvider menerima FirebaseAuth.instance ---
        ChangeNotifierProvider<BookProvider>(
          create: (context) {
            final bookProvider = BookProvider(
              context.read<FirestoreService>(),
              firebase_auth.FirebaseAuth.instance, // <-- Berikan instance FirebaseAuth
            );
            bookProvider.initializeBooks(); // <-- Panggil untuk memulai pemuatan buku
            return bookProvider;
          },
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (context) => ProfileProvider(
            context.read<FirestoreService>(),
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