import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/views/admin/admin_homepage.dart';
import 'package:project/views/admin/add_voucher.dart';
import 'package:project/views/admin/admin_shop.dart';
import 'package:project/views/user/benefits.dart';
import 'package:project/views/user/home_page.dart';
import 'package:project/views/user/my_voucher.dart';
import 'package:project/views/user/registeration/introduction.dart';
import 'package:project/views/user/registeration/profile.dart';
import 'package:project/views/user/registeration/sign_in.dart';
import 'package:project/views/user/registeration/sign_up.dart';
import 'package:project/models/cart.dart';
import 'package:project/views/staff/redeem_fail.dart';
import 'package:project/views/staff/scan_voucher.dart';
import 'package:project/views/user/shop/cart_page.dart';
import 'package:project/views/user/shop/user_shop.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/firebase_options.dart';
import 'package:project/theme.dart';
import 'package:project/views/staff/add_point.dart';
import 'package:project/views/staff/add_success.dart';
import 'package:project/views/staff/redeem-success.dart';
import 'package:project/views/staff/scan_member.dart';
import 'package:project/views/staff/staff_home_page.dart';
import 'package:provider/provider.dart';


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
    return MultiProvider(
      providers: [
          ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
         theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          color: AppTheme.primaryColor,
          iconTheme: IconThemeData(
            color: Colors.white, // Change icon color to white
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: AppTheme.primaryColor,
          unselectedItemColor: Colors.white,
        ),
      ),
      
          initialRoute: determineInitialRoute(),
      
          routes: {
            '/nav-bar':(context) => BottomNavBar(),
            '/sign-in': (context) => SignInPage(),
            '/sign-up': (context) => SignUpPage(),
            '/introduction' : (context) => IntroductionPage(),
            '/home-page': (context) => HomePage(),
            '/benefits': (context) => Benefits(),
            '/profile': (context) => Profile(),
            '/shop' : (context) => VoucherShop(),
            '/staff-home-page': (context) => StaffHomePage(),
            '/scan-member': (context) => ScanMember(),
            '/add-point': (context) => AddPoint(),
            '/add-point-success': (context) => AddPointSuccess(),
            '/scan-voucher': (context) => ScanVoucher(),
            '/redeem-success': (context) => RedeemSuccess(),
            '/redeem-fail': (context) => RedeemFail(),
            '/admin-home-page': (context) => AdminHomePage(),
            '/admin-shop' : (context) => VoucherListPage(),
            '/add-voucher': (context) => AddVoucher(),
            '/my-voucher' : (context) => MyVoucher(),
            '/cart' : (context) => MyCart(),
            }
            ),
    );
  }

  String determineInitialRoute() {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already signed in
      if (user.uid == "UQFYFsUXnLbxhLivf7X2XUhuQXC2") {
        return '/staff-home-page';
      } else if (user.uid == "gROiWhOTXxYtGgiIU2rJFz0HOYC3") {
        return '/admin-home-page';
      } else {
        return '/nav-bar';
      }
    }
    // User not signed in, navigate to the sign-in page
    return '/sign-in';
  }
}

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 1;

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
          VoucherShop(),
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
