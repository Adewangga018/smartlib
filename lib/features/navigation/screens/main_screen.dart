import 'package:flutter/material.dart';
import 'package:smartlib/common/theme/app_colors.dart';
import 'package:smartlib/features/catalog/screens/catalog_screen.dart';
import 'package:smartlib/features/favorite/screens/favorite_screen.dart';
import 'package:smartlib/features/to_read_list/screens/to_read_list_screen.dart';
import 'package:smartlib/features/review/screens/finished_books_screen.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    CatalogScreen(),
    FavoriteScreen(),
    ToReadListScreen(),
    FinishedBooksScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Katalog',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'To-Read',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Selesai',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryBlue,
        // --- PERUBAHAN DI SINI ---
        unselectedItemColor: Colors.grey, // Nama parameter yang benar
        // --- AKHIR PERUBAHAN ---
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}