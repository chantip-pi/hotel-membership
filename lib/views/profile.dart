import 'package:flutter/material.dart';
import 'package:project/theme.dart';

class Profile extends StatelessWidget {
  Profile({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.backgroundColor,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
        ),
        body: Stack(
          children: [
            Image.asset(
              'assets/images/backgrounddemo.jpg',
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  _ProfileImage(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, 240, 16, 0),
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
                    _ProfileInfo(title: 'Name-Surname', value: 'John Smith'),
                    _ProfileInfo(title: 'Gender', value: 'Male'),
                    _ProfileInfo(title: 'Email', value: 'john@gmail.com'),
                    _ProfileInfo(title: 'Phone Number', value: '09xxxxxxxx'),
                    _ProfileInfo(title: 'Birth Date', value: '20 Feb 1993'),
                    _ProfileInfo(title: 'Address', value: '50 NgamWongwan road, LadYao,Chatuchak, Bangkok, 10900'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Sign out
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _ProfileImage() {
  return ClipOval(
    child: Image.asset(
      'assets/images/profile.png',
      width: 150,
      height: 150,
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
