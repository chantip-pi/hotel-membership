import 'package:flutter/material.dart';
import 'package:project/theme.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Notifications',
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          color: AppTheme.backgroundColor,
          child: Column(
            children: [
              Expanded(
                child: _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {

    List<String> itemList = [
      'noti1', 'noti2', 'noti3',
    ];

    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {

          },
          child: Column(
            children: [
              ListTile(
                title: Text(itemList[index]),
              ),
              Divider(
                color: AppTheme.primaryColor,
                thickness: 1.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
