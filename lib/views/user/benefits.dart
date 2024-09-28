import 'package:flutter/material.dart';
import 'package:project/utils/theme.dart';

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
        title: const Text(
          'Membership Benefits',
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
      body: Container(
        color: AppTheme.backgroundColor,
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

  PreferredSizeWidget _buildTabBar() {
    double tabWidth = MediaQuery.of(context).size.width / _categories.length;

    return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Container(
        height: 50,
        color: Colors.white,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(top: 15),
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
                      color: _selectedIndex == index
                          ? AppTheme.primaryColor
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildListView() {

    List<String> itemList;
    switch (_selectedIndex) {
      case 0:
        itemList = ['• 30% off total food bill up to 10 persons valid at all participating restaurants and bars at restaurant',
                    '• Discount for food at Sunday Brunch\n   2 persons 50% off on food\n   3 persons 33% off\n   4 person 25% off\n   5 persons & above 20% off', 
                    '• 20% off food & beverage at participating restaurant'];
        break;
      case 1:
        itemList = ['• Earn 5% cash back for free after spending more than 10,000 baht at our hotel.',
                    '• Earn 10% cash back for free after spending more than 25,000 baht at our hotel.',
                    '• Receive 1,500 baht cash vouchers to be redeemed for future stays, dining, or other hotel amenities.'];
        break;
      case 2:
        itemList = ['• Upon arrival, guests will receive a complimentary gift basket filled with local snacks, fruits, and beverages.',
                    '• First time guests will receive vouchers for complimentary spa treatments, such as massages, facials, or manicures.',
                    '• After the accumulation of more than 5 nights stay (not necessarily consecutive), guests will be offered a courtesy upgrade to a superior room category.'];
        break;
      default:
        itemList = [];
        break;
    }

    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              title: Text(
                itemList[index],
              ),
            ),
            const Divider(
              color: AppTheme.primaryColor,
              thickness: 1.0,
            ),
          ],
        );
      },
    );
  }
}
