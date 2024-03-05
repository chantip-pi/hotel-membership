import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/services/user_service.dart';
import 'package:project/utils/format_string.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Map<String, dynamic>?> _currentUserFuture;
  late String? name;
  late String? surname;
  late String memberID;
  late int? points;

  @override
  void initState() {
    super.initState();

    _currentUserFuture =
        UserService().getUserById(FirebaseAuth.instance.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
            onPressed: () => {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _currentUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.primaryColor,
                  ),
                ),
              );
            } else {
              if (snapshot.hasData && snapshot.data != null) {
                final currentUser = snapshot.data!;
                name = currentUser['name'] as String?;
                surname = currentUser['surname'] as String?;
                memberID = currentUser['memberID'] as String;
                points = currentUser['points'] as int?;
              }

              return Container(
                color: AppTheme.backgroundColor,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                        children: <Widget>[
                        Column(
                            children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: screenHeight * 0.025)),
                            Stack(
                                children: [
                                Container(
                                    alignment: Alignment.bottomCenter,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10)),
                                      color: Colors.white,
                                    ),
                                    height: screenHeight * 0.05,
                                    width: screenWidth * 0.9,
                                    child: const Text(
                                    'MILVERTON CLUB',
                                    style: TextStyle(
                                        color: AppTheme.primaryColor,
                                    ),
                                    ),
                                ),
                                ],
                            ),
                            Container(
                                height: screenHeight * 0.28,
                                width: screenWidth * 0.9,
                                decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                image: DecorationImage(
                                    image: AssetImage('assets/images/backgrounddemo.jpg'),
                                    fit: BoxFit.cover,
                                ),
                                ),
                                child: Stack(
                                children: <Widget>[
                                    Column(
                                    children: <Widget>[
                                        _cardTextAlignment(Alignment.topCenter, EdgeInsets.only(top: screenHeight * 0.02), 'Your current points', FontWeight.bold, 20),
                                        _cardTextAlignment(Alignment.topCenter, EdgeInsets.only(top: screenHeight * 0.005), '$points Points', FontWeight.bold, 20),
                                    ],
                                    ),
                                    Stack(
                                    children: <Widget>[
                                        _cardTextAlignment(Alignment.bottomLeft, EdgeInsets.fromLTRB(screenWidth * 0.03, 0, 0, screenHeight * 0.045), FormatUtils.addSpaceToNumberString(memberID), FontWeight.normal, 16),
                                        _cardTextAlignment(Alignment.bottomLeft, EdgeInsets.fromLTRB(screenWidth * 0.03, 0, 0, screenHeight * 0.02), '$name $surname', FontWeight.normal, 16)
                                    ],
                                    ),
                                ],
                                ),
                            ),
                            ],
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(screenWidth * 0.41, screenHeight * 0.025, 0, 0),
                            child: SvgPicture.asset(
                            'assets/icons/LOGO.svg',
                            height: screenHeight * 0.035,
                            ),
                        ),
                        ],
                    ),
                    Padding(padding: EdgeInsets.all(screenWidth * 0.03)),
                    _buildMyVouchersBlock(screenHeight, screenWidth),
                    Padding(padding: EdgeInsets.all(screenHeight * 0.01)),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                        _buildEarnPointsBlock(screenHeight, screenWidth),
                        Padding(padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02)),
                        _buildBenefitsBlock(screenHeight, screenWidth),
                        ],
                    ),
                    ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMyVouchersBlock(double screenHeight, double screenWidth) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(215, 191, 152, 1),
            ),
            height: screenHeight * 0.2,
            width: screenWidth * 0.9,
            child: Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.3, screenHeight * 0.13, 0, 0),
            child: const Text(
              'MY VOUCHERS',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: screenHeight * 0.05)),
        Padding(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.33, screenHeight * 0.03, 0, 0),
            child: SvgPicture.asset(
              'assets/icons/Ticket_use_light.svg',
              height: screenHeight * 0.09,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardTextAlignment(Alignment align, EdgeInsets padding, String str, FontWeight fontWeight, double fontSize) {
    return Align(
      alignment: align,
      child: Padding(
        padding: padding,
          child: Text(
            str,
            style: TextStyle(
              color: Colors.white,
              fontWeight: fontWeight,
              fontSize: fontSize,
            ),
          ),
        ),
    );
  }

  Widget _buildEarnPointsBlock(double screenHeight, double screenWidth) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(215, 191, 152, 1),
            ),
            height: screenHeight * 0.2,
            width: screenWidth * 0.43,
            child: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.065, screenHeight * 0.14, 0, 0),
              child: const Text(
                'EARN POINTS',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.13, screenHeight * 0.05, 0, 0),
            child: SvgPicture.asset(
              'assets/icons/qr.svg',
              height: screenHeight * 0.07,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBenefitsBlock(double screenHeight, double screenWidth) {
    return GestureDetector(
      onTap: () => {
        Navigator.pushNamed(context, '/benefits'),
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromRGBO(215, 191, 152, 1),
            ),
            height: screenHeight * 0.2,
            width: screenWidth * 0.43,
            child: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.12, screenHeight * 0.14, 0, 0),
              child: const Text(
                'BENEFITS',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.15, screenHeight * 0.06, 0, 0),
            child: SvgPicture.asset(
              'assets/icons/benefit.svg',
              height: screenHeight * 0.06,
            ),
          ),
        ],
      ),
    );
  }
}
