import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/theme.dart';


class VoucherShop extends StatefulWidget {
  const VoucherShop({Key? key}) : super(key: key);

  @override
  State<VoucherShop> createState() => _VoucherShopState();
}

class _VoucherShopState extends State<VoucherShop> {
  int _selectedIndex = 0;

  final List<String> _categories = ['Discount', 'Cash', 'Gift'];

  final VoucherService _voucherService = VoucherService(); 

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            color: AppTheme.backgroundColor,
            child: Column(
              children: [
                _buildTabBar(),
                _buildVouchersList(),
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
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVouchersList() {
    String selectedCategory = _categories[_selectedIndex];

    return StreamBuilder<QuerySnapshot>(
      stream: _voucherService.getVoucherStreamByCategory(selectedCategory),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No vouchers available.');
        } else {
          var vouchers = snapshot.data!.docs.where((doc) => doc['onShop'] == true).toList();
          return Expanded(
            child: ListView.builder(
              itemCount: vouchers.length,
              itemBuilder: (context, index) {
                var voucher = vouchers[index];
                return ListTile(
                  title: Text(voucher['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Points: ${voucher['points']}'),
                      Text('Voucher Type: ${voucher['voucherType']}'),
                    ],
                  ),
                  // Add more details if needed
                );
              },
            ),
          );
        }
      },
    );
  }


}
