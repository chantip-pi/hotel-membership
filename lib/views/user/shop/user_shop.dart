import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:project/models/cart.dart';
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
    Widget _buildVouchersGrid() {
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
                .where((doc) =>
                    doc['onShop'] == true &&
                    doc['voucherType'] == _categories[_selectedIndex])
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
                return Builder(
                  builder: (context) {
                    var voucher = vouchers[index];
                    var voucherID = voucher.id;
                    var isInCart = context.select<Cart, bool>(
                      (cart) => cart.cartItems.any((element) =>
                          element.voucherID == voucherID),
                    );
                    return Card(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PurchaseVoucher(
                                voucherID: voucherID,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (voucher['imageUrl'] != null)
                              Stack(children: [
                                Image.network(
                                  voucher['imageUrl'],
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  top: 10.0,
                                  right: 10.0,
                                  child: InCartCircle(
                                    isInCart: isInCart,
                                  ),
                                )
                              ]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(voucher['name']),
                                  Text('Points: ${voucher['points']}'),
                                  Text(
                                    'Due Date: ${FormatUtils.formatDate(voucher['dueDate'])}',
                                  ),
                                  Text(
                                      'Voucher Type: ${voucher['voucherType']}'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
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
          title: const Text('Shop'),
          bottom: _buildTabBar(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
          backgroundColor: Colors.black,
          child: const Icon(
            Icons.shopping_basket_outlined,
            color: Colors.white,
          ),
          shape: CircleBorder(),
        ),
        body: _buildVouchersGrid(),
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
}

class InCartCircle extends StatelessWidget {
  final bool isInCart;

  InCartCircle({required this.isInCart});

  @override
  Widget build(BuildContext context) {
    return isInCart
        ? Container(
            decoration: const BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white, // Customize the color as needed
            ),
            child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.check, color: Colors.black)),
          )
        : const SizedBox.shrink(); // Return an empty SizedBox if not in cart
  }
}
