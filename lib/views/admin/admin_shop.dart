import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/theme.dart';
import 'package:project/utils/format_string.dart';

class VoucherListPage extends StatefulWidget {
  @override
  _VoucherListPageState createState() => _VoucherListPageState();
}

class _VoucherListPageState extends State<VoucherListPage> {
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
            return const Text('No vouchers available.');
          } else {
            var vouchers = snapshot.data!.docs
                .where((doc) =>
                    doc['onShop'] == true &&
                    doc['voucherType'] == _categories[_selectedIndex]) 
                .toList();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: vouchers.length,
                itemBuilder: (context, index) {
                  var voucher = vouchers[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: AppTheme.lightGoldColor, // Set background color
                    child: InkWell(
                      onTap: () {
                        // TODO: show voucher detail
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (voucher['imageUrl'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.only(
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
                          if (voucher['imageUrl'] == null)
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0),
                              ),
                              child: Image.asset(
                                'assets/images/default-voucher-image.png',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  voucher['name'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                    'Valid Until ${(FormatUtils.formatDate(voucher['dueDate']))}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${voucher['points']} Points',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            width: 40.0,
                                            height: 40.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: IconButton(
                                              icon: Icon(Icons.delete,
                                                  color: Colors.black),
                                              onPressed: () {
                                                _showDeleteConfirmationDialog(
                                                    voucher.id);
                                              },
                                            ),
                                          )),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
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
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          centerTitle: true,
          title: const Text(
            'Manage Shop',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, '/add-voucher');
              },
            ),
          ],
          bottom: _buildTabBar(),
        ),
        body: buildVouchersGrid(),
        backgroundColor: AppTheme.backgroundColor,
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
                      color: Colors.white,
                      width: _selectedIndex == index ? 3.0 : 1.0,
                    ),
                  ),
                ),
                child: Center(
                  child: Text(
                    _categories[index],
                    style: TextStyle(
                      color: Colors.white,
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

  Future<void> _showDeleteConfirmationDialog(String voucherId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white, // Set background color
          title: Text('Confirm Deletion',
              style: TextStyle(color: Colors.black)), // Set title text color
          content: Text(
              'Do you really want to remove this voucher from the shop?',
              style: TextStyle(color: Colors.black)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel',
                  style:
                      TextStyle(color: Colors.black)), // Set button text color
            ),
            TextButton(
              onPressed: () {
                // Delete the voucher
                _voucherService.deleteVoucher(voucherId);
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
