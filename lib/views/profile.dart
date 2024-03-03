import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/theme.dart';
import 'package:project/services/user_service.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<Map<String, dynamic>?> _currentUserFuture;
    late String? name;
    late String? surname ;
    late String? memberID;
    late int? points;
    
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
          name = currentUser?['name'] as String?;
          surname = currentUser?['surname'] as String?;
          memberID = currentUser?['memberID'] as String?;
          points = currentUser?['points'] as int?;
        });
          print('User Details by ID: ${currentUser}');
          print('Name: ${name}');
        } else {
          print('User not found or error getting user details by ID');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: AppTheme.backgroundColor,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
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
            ),
            Center(
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: screenHeight * 0.035)),
                  _ProfileImage(screenHeight),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.24, screenHeight * 0.016, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    _ProfileInfo(title: 'Name-Surname', value: '${name} ${surname}'),
                    _ProfileInfo(title: 'Gender', value: 'gender'),
                    _ProfileInfo(title: 'Email', value: 'email'),
                    _ProfileInfo(title: 'Phone Number', value: 'phonenumber'),
                    _ProfileInfo(title: 'Birth Date', value: 'birthdate'),
                    _ProfileInfo(title: 'Address', value: 'address'),
                    SizedBox(height: screenHeight * 0.01),
                    SizedBox(
                      width: double.infinity,
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        onPressed: () {
                          //TODO Sign out
                        },
                        child: Text(
                          'Sign out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppTheme.backgroundColor),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ProfileImage(double screenHeight) {
    return ClipOval(
      child: Image.asset(
        'assets/images/profile.png',
        width: screenHeight * 0.15,
        height: screenHeight * 0.15,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _ProfileInfo({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16),
        ),
        Divider(
          color: AppTheme.primaryColor,
          thickness: 1.0,
        ),
      ],
    );
  }
}
