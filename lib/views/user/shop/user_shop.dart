import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/format_string.dart';
import 'package:project/views/user/shop/purchase_voucher.dart';

class VoucherShop extends StatefulWidget {

  @override
  _VoucherShopState createState() => _VoucherShopState();
}

class _VoucherShopState extends State<VoucherShop> {
  final VoucherService _voucherService = VoucherService();
  int _selectedIndex = 0;

  final List<String> _categories = ['Discount', 'Cash', 'Gift'];

  @override
  Widget build(BuildContext context) {

  Widget buildVouchersGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _voucherService.getVoucherStream(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No vouchers available.');
        } else {
          var vouchers = snapshot.data!.docs
              .where((doc) => doc['onShop'] == true && doc['voucherType'] == _categories[_selectedIndex])
              .toList();
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              var voucher = vouchers[index];
              var voucherId = voucher.id;
              return Card(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PurchaseVoucher(
                          voucherId: voucherId,
                      )),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (voucher['imageUrl'] != null)
                        Image.network(
                          voucher['imageUrl'],
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(voucher['name']),
                            Text('Points: ${voucher['points']}'),
                            Text('Due Date: ${FormatUtils.formatDate(voucher['dueDate'])}'),
                            Text('Voucher Type: ${voucher['voucherType']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  return DefaultTabController(
    length: _categories.length,
    child: Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        bottom: _buildTabBar(),
      ),
      body: Column(
        children: [
          Expanded(
            child: buildVouchersGrid(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: _buildCartButton(),
          )
        ],
      ),
    ),
  );
}

  PreferredSizeWidget _buildTabBar() {
  double tabWidth = MediaQuery.of(context).size.width / _categories.length;

  return PreferredSize(
    preferredSize: Size.fromHeight(50),
    child: Container(
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
                      Text('Due Date: ${FormatUtils.formatDate(voucher['dueDate'])}'),
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

  Widget _buildCartButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/cart');
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.03),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.black,
          ),
          height: screenWidth * 0.18,
          width: screenWidth * 0.18,
          child: Icon(
            Icons.shopping_basket_outlined,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
