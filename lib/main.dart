import 'package:flutter/material.dart';
import 'package:project/views/benefits.dart';
import 'package:project/views/home_page.dart';
import 'package:project/views/profile.dart';
import 'package:project/views/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/views/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        initialRoute: '/home-page',
        routes: {
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home-page': (context) => HomePage(),
          '/benefits': (context) => Benefits(),
          '/profile': (context) => Profile(),
          }
          );
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomePage(),
          HomePage(),
          Profile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'SHOP'),
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'HOME'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'PROFILE'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
