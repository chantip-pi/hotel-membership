import 'package:flutter/material.dart';
import 'package:project/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';

//TODO change it to be responsive (use expand, phone size * ratio)

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
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: AppTheme.backgroundColor,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(top : 30)),
                      Stack(
                        children: <Widget>[
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
                        ],
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
                                        fontSize: 20,
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
                                        fontSize: 20,
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
                                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 40),
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
                                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 20),
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(180, 30, 0, 0),
                    child: SvgPicture.asset(
                      'assets/icons/LOGO.svg',
                      height: 35,
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.all(15)),
              GestureDetector(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(215, 191, 152, 1),
                      ),
                      height: 170,
                      width: double.infinity,
                      child : Padding(
                        padding: EdgeInsets.fromLTRB(120, 120, 0, 0),
                          child: Text(
                            'MY VOUCHERS',
                            style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(125, 20, 0, 0),
                      child: SvgPicture.asset(
                        'assets/icons/Ticket_use_light.svg',
                        height: 100,
                      ),
                    ),
                  ],
                )
              ),
              Padding(padding: EdgeInsets.all(10)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(215, 191, 152, 1),
                          ),
                          height: 170,
                          width: 190,
                          child : Padding(
                            padding: EdgeInsets.fromLTRB(30, 120, 0, 0),
                            child: Text(
                              'EARN POINTS',
                              style: TextStyle(
                              fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(60, 40, 0, 0),
                          child: SvgPicture.asset(
                            'assets/icons/qr.svg',
                            height: 70,
                          ),
                        ),
                      ],
                    )
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                  GestureDetector(
                    onTap: () => {
                      Navigator.pushNamed(context, '/benefits'),
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color.fromRGBO(215, 191, 152, 1),
                          ),
                          height: 170,
                          width: 190,
                          child : Padding(
                            padding: EdgeInsets.fromLTRB(50, 120, 0, 0),
                            child: Text(
                              'BENEFITS',
                              style: TextStyle(
                              fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(60, 45, 0, 0),
                          child: SvgPicture.asset(
                            'assets/icons/benefit.svg',
                            height: 60,
                          ),
                        ),
                      ],
                    )
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
