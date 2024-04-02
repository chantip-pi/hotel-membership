import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart'; 
import 'package:project/utils/theme.dart';
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
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No vouchers available.');
          } else {
            var vouchers = snapshot.data!.docs
                .where((doc) =>
                    doc['onShop'] == true &&
                    doc['voucherType'] == _categories[_selectedIndex])
                .toList();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        (cart) => cart.cartItems
                            .any((element) => element.voucherID == voucherID),
                      );
                      String name = voucher['name'];
                      String displayName;
                      if (name.length > 30) {
                        displayName = '${name.substring(0, 30)}...';
                      } else {
                        displayName = name;
                      }
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: AppTheme.lightGoldColor,
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
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        topRight: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        voucher['imageUrl'],
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      top: 10.0,
                                      right: 10.0,
                                      child: InCartCircle(
                                        isInCart: isInCart,
                                      ),
                                    )
                                  ],
                                ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    'Valid Until ${(FormatUtils.formatDate(voucher['dueDate']))}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    )),
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${voucher['points']} Points',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      );
    }

    return DefaultTabController(
      length: _categories.length,
      child: Scaffold(
        appBar: AppBar(
          bottom: _buildTabBar(),
          centerTitle: true,
          backgroundColor: AppTheme.primaryColor,
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
        body: Column(
          children: [
            _buildBannerCarousel(), // Add the banner carousel
            Expanded(
              child:
                  _buildVouchersGrid(), // Move the vouchers grid inside Expanded widget
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel() {
    List<String> bannerImages = [
      'assets/images/banner1.png',
      'assets/images/banner2.jpg',
      'assets/images/banner3.jpg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
      ),
      items: bannerImages.map((item) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              item,
              fit: BoxFit.cover,
              width: 1000.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    double tabWidth = MediaQuery.of(context).size.width / _categories.length;

    return PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: Container(
        height: 50,
        color: Colors.white,
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
              color: Colors.white,
            ),
            child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.check, color: Colors.black)),
          )
        : const SizedBox.shrink();
  }
}
