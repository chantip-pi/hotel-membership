import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/services/user_purchase.dart';
import 'package:project/services/user_service.dart';
import 'package:project/utils/format_string.dart';
import 'package:project/views/user/vouhcer_item.dart';

class MyVoucher extends StatefulWidget {
  const MyVoucher({super.key});

  @override
  State<MyVoucher> createState() => _MyVoucherState();
}

class _MyVoucherState extends State<MyVoucher> {
  late String _currentUserID;
  late Future<List<Map<String, dynamic>>> _userPurchasesWithVoucherInfo;

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
        automaticallyImplyLeading: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userPurchasesWithVoucherInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No vouchers found');
          }
          List<Map<String, dynamic>> userPurchasesWithVoucherInfo =
              snapshot.data!;
          List<Widget> voucherWidgets =
              userPurchasesWithVoucherInfo.map((purchase) {
            var voucherInfo = purchase['voucherInfo'] as Map<String, dynamic>;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VoucherItem(
                            voucherInfo: voucherInfo,
                            purchaseID: purchase['purchaseID']
                          )),
                );
              },
              child: ListTile(
                title: Text(voucherInfo['name']),
                subtitle: Text("Valid Until ${FormatUtils.formatDate(voucherInfo['dueDate'])}"),
              ),
            );
          }).toList();

          return ListView(
            children: voucherWidgets,
          );
        },
      ),
    );
  }
}
