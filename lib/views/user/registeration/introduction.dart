import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/services/user_service.dart';
import 'package:project/utils/theme.dart';
import 'package:project/utils/format_string.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    setState(() {
      _currentPage = _pageController.page?.round() ?? 0;
    });
  }

  final List<Widget> _pages = [
    IntroPageOne(),
    IntroPageTwo(),
    IntroPageThree(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: _pages,
            ),
          ),
          PageIndicator(
            pageCount: _pages.length,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }
}

class PageIndicator extends StatelessWidget {
  final int pageCount;
  final int currentPage;

  const PageIndicator({Key? key, required this.pageCount, required this.currentPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.1),
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            pageCount,
            (index) => _buildIndicator(index),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    final bool isCurrentPage = index == currentPage;
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage ? Colors.black87 : Colors.grey[400],
      ),
    );
  }
}

class IntroPageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: AppTheme.backgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: SvgPicture.asset(
              'assets/icons/LOGO.svg',
              height: MediaQuery.of(context).size.height * 0.1,
            ),
          ),
          Padding(padding: EdgeInsets.all(screenHeight * 0.005)),
          const Text(
            'Welcome to\nMilverton Club,',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          Padding(padding: EdgeInsets.all(screenHeight * 0.005)),
          const Text(
            ' where exclusive experiences await\nExplore our special membership deals\nand enjoy unique benefits with us',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class IntroPageTwo extends StatefulWidget {
  @override
  _IntroPageTwoState createState() => _IntroPageTwoState();
}

class _IntroPageTwoState extends State<IntroPageTwo> {
  late Future<Map<String, dynamic>?> _currentUserFuture;
  String? name;
  String? surname;
  String memberID = '';
  int? points;

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
    return Container(
      color: AppTheme.backgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _currentUserFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          } else if (snapshot.hasError) {
            return _buildErrorWidget();
          } else if (snapshot.hasData && snapshot.data != null) {
            final currentUser = snapshot.data!;
            return _buildContentWidget(currentUser, screenHeight, screenWidth);
          } else {
            return _buildErrorWidget();
          }
        },
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return const Center(
      child: Text('Error fetching user data'),
    );
  }

  Widget _buildContentWidget(Map<String, dynamic> currentUser, double screenHeight, double screenWidth) {
    name = currentUser['name'] as String?;
    surname = currentUser['surname'] as String?;
    memberID = currentUser['memberID'] as String;
    points = currentUser['points'] as int?;

    return Container(
      color: AppTheme.backgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Stack(
            children: [
              Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: screenHeight * 0.1)),
                  Stack(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
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
                        bottomRight: Radius.circular(10),
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/member-background.png'),
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
                padding: EdgeInsets.fromLTRB(screenWidth * 0.40, screenHeight * 0.098, 0, 0),
                child: SvgPicture.asset(
                  'assets/icons/LOGO.svg',
                  height: screenHeight * 0.035,
                ),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.all(screenHeight * 0.015)),
          const Text(
            'Join us, and unlock special perks, including exclusive membership with',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Padding(padding: EdgeInsets.all(screenHeight * 0.005)),
          const Text(
            '1,000 points free!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}


class IntroPageThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: AppTheme.backgroundColor,
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Experience the best and enjoy our exclusive offers now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: screenWidth * 0.75,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/nav-bar');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'GO',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Icon(Icons.arrow_forward, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
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