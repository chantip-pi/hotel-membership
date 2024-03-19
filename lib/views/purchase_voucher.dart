import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/views/user_cart.dart';
import 'package:provider/provider.dart';

class PurchaseVoucher extends StatefulWidget {
  final String voucherId;
  const PurchaseVoucher({Key? key, required this.voucherId}) : super(key: key);

  @override
  State<PurchaseVoucher> createState() => _PurchaseVoucherState();
}

class _PurchaseVoucherState extends State<PurchaseVoucher> {
  late Stream<QuerySnapshot<Object?>> _voucher;

  @override
  void initState() {
    super.initState();
    _voucher = VoucherService().getVoucherByIDs(widget.voucherId);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Purchase Voucher'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _voucher,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Text(snapshot.data!.toString());
          } else {
            final voucherData = snapshot.data!;
            Map<String, dynamic> voucherDataMapped = voucherData as Map<String, dynamic>;
            // Map<String, dynamic> voucherDataMapped = querySnapshotToMap(voucherData);

            //might delete later
            // final List<Map<String, dynamic>> mappedData = snapshot.data!.docs.map((doc) {
            //   return doc.data() as Map<String, dynamic>; // Convert each document to a map
            // }).toList();
            final List<Map<String, dynamic>> mappedData = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>; // Convert each document to a map
              final voucherName = data['name'] ?? ''; // Provide a default value if the field doesn't exist
              final price = data['price'] ?? ''; // Provide a default value if the field doesn't exist
              final imageUrl = data['imageUrl'] ?? '';
              final terms = data['terms'] ?? '';
              final timestamp = data['timestamp'] ?? '';
              return {
                'voucherName': voucherName,
                'price': price,
                'imageUrl' : imageUrl,
                'terms' : terms,
                'timestamp' : timestamp,
              }; // Return a map with string keys
            }).toList();
            //delete til here

            DateTime dateTime = voucherDataMapped['timestamp'].toDate();
            String formattedValid = DateFormat('dd MMM yyyy').format(dateTime);
            int number = 1;

            return Column(
              children: [  
                Image.asset(
                  (voucherDataMapped['imageUrl']),
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(padding: EdgeInsets.only(top: screenHeight * 0.01)),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(voucherDataMapped['name']),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(formattedValid),
                        ),
                        Padding(padding: EdgeInsets.only(top: screenHeight * 0.02)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: screenHeight * 0.02)),
                        Text(voucherDataMapped['termsCondition']),
                        Padding(padding: EdgeInsets.only(top: screenHeight * 0.03)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildAmountButton('-', number),
                              Padding(padding: EdgeInsets.only(left: screenWidth * 0.05)),
                              Text(number.toString()),
                              Padding(padding: EdgeInsets.only(left: screenWidth * 0.05)),
                              _buildAmountButton('+', number),
                            ],
                          ),
                        ),
                        _buildToCartButton(voucherDataMapped),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }          
        },
      ),
    );
  }

  Widget _buildAmountButton(String buttonText, int number) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () {
        if (buttonText == '+') {
          number += 1;
        } else {
          number -= 1;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
        ),
        width: screenWidth * 0.05,
        height: screenWidth * 0.05,
        child: Center(child: Text(buttonText)),
      ),
    );
  }

  Widget _buildToCartButton(Map<String, dynamic> voucherData) {
    final Product product = Product(
      name: voucherData['name'],
      price: voucherData['price'],
      imageUrl: voucherData['imageUrl'],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              onPressed: () {
                final cart = Provider.of<Cart>(context, listen: false);
                cart.addToCart(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added to cart'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Center(
                child: Text(
                  'Add to cart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

// Map<String, dynamic> querySnapshotToMap(QuerySnapshot<Object?> snapshot) {
//   Map<String, dynamic> resultMap = {};

//   for (QueryDocumentSnapshot<Object?> documentSnapshot in snapshot.docs) {
//     // Get the data from each document
//     Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    
//     // Assuming each document has an ID field
//     String documentId = documentSnapshot.id;

//     // Add the data to the result map with document ID as the key
//     resultMap[documentId] = data;
//   }

//   return resultMap;
// }
