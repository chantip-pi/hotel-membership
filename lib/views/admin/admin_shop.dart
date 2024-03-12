import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project/services/voucher_service.dart';
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
            return Card(
              child: InkWell(
                onTap: () {
                  // Handle voucher click
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
                          Text(
                            'Due Date: ${(FormatUtils.formatDueDate(voucher['dueDate']))}',
                          ),
                          Text('Voucher Type: ${voucher['voucherType']}'),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _showDeleteConfirmationDialog(voucher.id);
                      },
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
          title: Text('Manage Shop'),
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


  Future<void> _showDeleteConfirmationDialog(String voucherId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Do you really want to remove this voucher from the shop?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
                      Text('Due Date: ${_formatDueDate(voucher['dueDate'])}'),
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

String _formatDueDate(Timestamp timestamp) {
  DateTime dueDate = timestamp.toDate(); // Convert Timestamp to DateTime
  return DateFormat('dd MMM yyyy').format(dueDate); // Format the DateTime
}

}
