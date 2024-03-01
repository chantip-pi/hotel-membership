import 'package:flutter/material.dart';
import 'package:project/views/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/views/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/firebase_options.dart';
import 'package:project/views/staff_pages/add-point.dart';
import 'package:project/views/staff_pages/redeem-voucher.dart';
import 'package:project/views/staff_pages/scan_member.dart';
import 'package:project/views/staff_pages/staff_home_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeFirebase();
  runApp(const MyApp());
}

void initializeFirebase() async {
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          useMaterial3: true,
        ),
        initialRoute: '/sign-in',
        routes: {
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/staff-home-page': (context) => StaffHomePage(),
          '/add-point': (context) => AddPoint(),
          '/staff-redeem': (context) => StaffRedeem(),
          '/scan-member': (context) => ScanMember()
          }
          );
  }
}
