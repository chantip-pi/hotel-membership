import 'package:flutter/material.dart';
import 'package:project/theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16.0), // Add symmetric padding
        child: Container(
          color: AppTheme.backgroundColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top : 30)),
                  Container(
                    alignment: Alignment.bottomCenter,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      color: Colors.white,
                    ),
                    height: 50,
                    width: double.infinity,
                    child: Text(
                      'MILVERTON CLUB',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                  Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                      image: DecorationImage(
                        image: AssetImage('assets/images/backgrounddemo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Text(
                                  'Your current points',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Text(
                                  '() Points',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 25),
                                child: Text(
                                  'User ID',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 0, 0, 8),
                                child: Text(
                                  'User Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.all(15)),
              GestureDetector(
                child: Container(
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromRGBO(215, 191, 152, 1),
                    image: DecorationImage(
                      image: AssetImage('assets/images/ticket.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                  height: 170,
                  width: double.infinity,
                  child : Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'MY VOUCHERS',
                      style: TextStyle(
                      fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(215, 191, 152, 1),
                        image: DecorationImage(
                          image: AssetImage('assets/images/qrcode.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      height: 170,
                      width: 190,
                      child : Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'EARN POINTS',
                          style: TextStyle(
                          fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/benefits'),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(215, 191, 152, 1),
                        image: DecorationImage(
                          image: AssetImage('assets/images/benefit.png'),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      height: 170,
                      width: 190,
                      child : Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'BENEFITS',
                          style: TextStyle(
                          fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
