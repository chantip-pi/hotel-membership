import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/views/benefits.dart';
import 'package:project/views/home_page.dart';
import 'package:project/views/profile.dart';
import 'package:project/views/sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/views/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/firebase_options.dart';
import 'package:project/views/staff_pages/add_point.dart';
import 'package:project/views/staff_pages/add_success.dart';
import 'package:project/views/staff_pages/redeem-voucher.dart';
import 'package:project/views/staff_pages/scan_member.dart';
import 'package:project/views/staff_pages/staff_home_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  runApp(const MyApp());
}

Future<void> initializeFirebase() async {
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
          
        initialRoute: determineInitialRoute(),
        routes: {
          '/sign-in': (context) => SignInPage(),
          '/sign-up': (context) => SignUpPage(),
          '/home-page': (context) => HomePage(),
          '/benefits': (context) => Benefits(),
          '/profile': (context) => Profile(),
          '/staff-home-page': (context) => StaffHomePage(),
          '/add-point': (context) => AddPoint(),
          '/staff-redeem': (context) => StaffRedeem(),
          '/scan-member': (context) => ScanMember(),
          '/add-point-success': (context) => AddPointSuccess(),
          }
          );
  }

  String determineInitialRoute() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already signed in
      if (user.uid == "UQFYFsUXnLbxhLivf7X2XUhuQXC2") {
        return '/staff-home-page';
      } else if (user.uid == "gROiWhOTXxYtGgiIU2rJFz0HOYC3") {
        // return '/admin-home-page';
      } else {

        // return '/home-page';
      }
    }
    // User not signed in, navigate to the sign-in page
    return '/sign-in';
  }
}
