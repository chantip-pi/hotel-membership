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
