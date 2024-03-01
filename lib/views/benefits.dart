import 'package:flutter/material.dart';
import 'package:project/theme.dart';

class Benefits extends StatefulWidget {
  @override
  _BenefitsState createState() => _BenefitsState();
}

class _BenefitsState extends State<Benefits> {
  int _selectedIndex = 0;

  final List<String> _categories = ['Discount', 'Cash', 'Gift'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Membership Benefits',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppTheme.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          color: AppTheme.backgroundColor,
          child: Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: _buildListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    double tabWidth = MediaQuery.of(context).size.width / _categories.length;

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 15),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              width: tabWidth,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black,
                    width: _selectedIndex == index ? 3.0 : 1.0,
                  ),
                ),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView() {

    List<String> itemList;
    switch (_selectedIndex) {
      case 0:
        itemList = ['Item 1 (Discount)', 'Item 2 (Discount)', 'Item 3 (Discount)'];
        break;
      case 1:
        itemList = ['Item 1 (Cash)', 'Item 2 (Cash)', 'Item 3 (Cash)'];
        break;
      case 2:
        itemList = ['Item 1 (Gift)', 'Item 2 (Gift)', 'Item 3 (Gift)'];
        break;
      default:
        itemList = [];
        break;
    }

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
