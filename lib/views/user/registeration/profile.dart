import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/theme.dart';
import 'package:project/services/user_service.dart';
import 'package:project/utils/format_string.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>?> _currentUserFuture;
  late String name = "Loading..";
  late String surname = "Loading..";
  late String memberID = "Loading..";
  late int points = 0;
  late String email = "Loading..";
  late String phone = "Loading..";
  late String gender = "Loading..";
  late String address = "Loading..";
  late Timestamp birthdate = Timestamp.now();

  @override
  void initState() {
    super.initState();
      
    // Initialize the future in the initState method
    _currentUserFuture = UserService().getUserById(FirebaseAuth.instance.currentUser!.uid);
    
    // Use the then callback to update the state when the future completes
    _currentUserFuture.then((currentUser) {
      if (currentUser != null) {
        // Successfully retrieved user details by ID
        setState(() {
          currentUser = currentUser;
          name = currentUser?['name'] as String;
          surname = currentUser?['surname'] as String;
          memberID = currentUser?['memberID'] as String;
          points = currentUser?['points'] as int;
          email = currentUser?['email'] as String;
          phone = currentUser?['phone'] as String;
          gender = currentUser?['gender'] as String;
          address = currentUser?['address'] as String;
          birthdate = currentUser?['birthdate'] as Timestamp;
        });
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    String formattedPhoneNumber = FormatUtils.formatPhoneNumber(phone);
    DateTime dateTime = birthdate.toDate();
    String formattedBirthdate = DateFormat('dd MMM yyyy').format(dateTime);

    return Container(
      color: AppTheme.backgroundColor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/backgrounddemo.jpg',
              width: screenWidth,
              fit: BoxFit.cover,
              height: screenHeight * 0.25,
            ),
            Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: screenHeight * 0.035)),
                  _profileImage(screenHeight),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.3, screenHeight * 0.016, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: screenHeight * 0.01)),
                    _profileInfo(title: 'Name-Surname', value: '$name $surname'),
                    _profileInfo(title: 'Gender', value: gender),
                    _profileInfo(title: 'Email', value: email),
                    _profileInfo(title: 'Phone Number', value: formattedPhoneNumber),
                    _profileInfo(title: 'Birthdate', value: formattedBirthdate),
                    _profileInfo(title: 'Address', value: address),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.03, bottom: screenHeight * 0.05),
                      child: SizedBox(
                        width: double.infinity,
                        height: screenHeight * 0.06,
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/sign-in');
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(AppTheme.backgroundColor),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.black),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Sign out',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImage(double screenHeight) {
    return ClipOval(
      child: Image.asset(
        'assets/images/profile.png',
        width: screenHeight * 0.15,
        height: screenHeight * 0.15,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _profileInfo({required String title, required String value}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(
              color: AppTheme.primaryColor,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }
}
