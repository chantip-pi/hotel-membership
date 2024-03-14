import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/services/user_purchase.dart';
import 'package:project/services/user_service.dart';

class MyVoucher extends StatefulWidget {
  const MyVoucher({super.key});

  @override
  State<MyVoucher> createState() => _MyVoucherState();
}

class _MyVoucherState extends State<MyVoucher> {
  late String _currentUserID;
  @override
  void initState() {
    super.initState();
    _currentUserID = FirebaseAuth.instance.currentUser!.uid;
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: true,
    ),
    body: FutureBuilder<Stream<QuerySnapshot<Object?>>>(
      future: UserPurchaseService().getVoucherStreamForUser(_currentUserID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No vouchers found');
        }
        // Process the stream using StreamBuilder
        return StreamBuilder<QuerySnapshot<Object?>>(
          stream: snapshot.data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Text('No vouchers found');
            }
            // Process the documents
            List<Widget> voucherWidgets = snapshot.data!.docs.map((doc) {
              var voucher = doc.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(voucher['name']),
                subtitle: Text(voucher['voucherType']),
                // Additional voucher fields...
              );
            }).toList();

            return ListView(
              children: voucherWidgets,
            );
          },
        );
      },
    ),
  );
}


       
  }

