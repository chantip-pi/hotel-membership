import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/services/user_purchase.dart';
import 'package:project/services/user_service.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/format_string.dart';
import 'package:project/views/vouhcer_item.dart';
import 'package:project/theme.dart';

class MyVoucher extends StatefulWidget {
  const MyVoucher({super.key});

  @override
  State<MyVoucher> createState() => _MyVoucherState();
}

class _MyVoucherState extends State<MyVoucher> {
  late String _currentUserID;
  late Future<List<Map<String, dynamic>>> _userPurchasesWithVoucherInfo;
  String voucherCategory = 'All';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentUserID = FirebaseAuth.instance.currentUser!.uid;
    _userPurchasesWithVoucherInfo =
        UserPurchaseService().getUserPurchasesWithVoucherInfo(_currentUserID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Vouchers',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userPurchasesWithVoucherInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No vouchers found');
          }
          // Process the retrieved user purchases with voucher info
          List<Map<String, dynamic>> userPurchasesWithVoucherInfo =
              snapshot.data!;    
          List<Widget> voucherWidgets =
              userPurchasesWithVoucherInfo.map((purchase) {
            var voucherInfo = purchase['voucherInfo'] as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                // setState(() {
                //   _selectedIndex;
                // });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VoucherItem(
                      voucherInfo: voucherInfo,
                      purchaseID: purchase['purchaseID']
                    )
                  ),
                );
              },
              child: _buildListTileByCase(voucherInfo),
            );
          }).toList();

          // return ListView(
          //   children: voucherWidgets,
          // );
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              _buildHorizontalList(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  color: AppTheme.primaryColor,
                  thickness: 1.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _textChanger(voucherCategory),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: ListView(
                  children: voucherWidgets,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHorizontalList() {
    List<String> icons = [
      'assets/icons/Ticket_use_light.svg',
      'assets/icons/discount.svg',
      'assets/icons/cash.svg',
      'assets/icons/gift.svg',
    ];

    List<String> labels = ['VOUCHER', 'DISCOUNT', 'CASH', 'GIFT'];

    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = index;
            });
          },
          child: Row(
            children: [
              _buildListBlock(icons[index], labels[index]),
            ],
          ),
        );
        },
      ),
    );
  }

  Widget _buildListBlock(String svgAsset, String text) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: screenWidth * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(215, 191, 152, 1),
        ),
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: screenHeight * 0.03)),
            SvgPicture.asset(
              svgAsset,
              height: screenWidth * 0.12,
            ),
            Padding(padding: EdgeInsets.only(top: screenHeight * 0.008)),
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget _textChanger(String category) {
    return Text(
      '$category Voucher',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }

  Widget _buildListTileByCase(Map<String, dynamic> voucherInfo) {
    String voucherCategory;
    if (_selectedIndex == 1) {
      voucherCategory = 'Discount';
    } else if (_selectedIndex == 2) {
      voucherCategory = 'Cash';
    } else {
      voucherCategory = 'Gift';
    }
    Map<String, dynamic> usingInfo = voucherInfo;
    VoucherService voucherService = VoucherService();
    Stream<QuerySnapshot> voucherStream = voucherService.getVoucherStreamByCategory(voucherCategory);
    if (_selectedIndex == 0) {
      return _buildListTile(voucherInfo);
    } else {
      usingInfo = voucherStream as Map<String, dynamic>;
      return _buildListTile(usingInfo);
    }
  }
  
  Widget _buildListTile(Map<String, dynamic> usingInfo) {
    return Container(
      decoration: const BoxDecoration( 
        border: Border(
          bottom: BorderSide(
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      child: ListTile(
        leading: Image.network(usingInfo['imageUrl']),
        title: Text(
          usingInfo['name'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quantity:'),
            const SizedBox(height: 5),
            Text("Valid Until ${FormatUtils.formatDate(usingInfo['dueDate'])}"),
          ],
        ),
        trailing: const Icon(
          Icons.navigate_next,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}
