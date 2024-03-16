import 'package:flutter/material.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/views/user_cart.dart';
import 'package:provider/provider.dart';

class PurchaseVoucher extends StatefulWidget {
  final Map<String, dynamic> voucherData;

  const PurchaseVoucher({Key? key, required this.voucherData}) : super(key: key);

  @override
  State<PurchaseVoucher> createState() => _PurchaseVoucherState();
}


class _PurchaseVoucherState extends State<PurchaseVoucher> {

  // late Future<Map<String, dynamic>?> _voucherData;
  // late String name;
  // late String valid;
  // late String termsAndConditions;
  // late String details;

  // @override
  // void initState() {
  //   super.initState();
      
  //   // Initialize the future in the initState method
  //   _voucherData = VoucherService().getVoucherStream() as Future<Map<String, dynamic>?>;
    
  //   // Use the then callback to update the state when the future completes
  //   _voucherData.then((currentVoucher) {
  //     if (currentVoucher != null) {
  //       // Successfully retrieved user details by ID
  //       setState(() {
  //         currentVoucher = currentVoucher;
  //         name = currentVoucher?['name'] as String;
  //         valid = currentVoucher?['surname'] as String;
  //         termsAndConditions = currentVoucher?['memberID'] as String;
  //         details = currentVoucher?['email'] as String;
  //       });
  //       }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final VoucherService _voucherService = VoucherService();

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Detail',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: 
      // FutureBuilder<DocumentSnapshot>(
      //   future: FirebaseFirestore.instance.collection('vouchers').doc('voucher_id').get(),
      //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Error: ${snapshot.error}'));
      //     }
      //     if (!snapshot.hasData || !snapshot.data!.exists) {
      //       return Center(child: Text('Voucher not found'));
      //     }
      //     var voucherData = snapshot.data!.data() as Map<String, dynamic>; 
        StreamBuilder<QuerySnapshot>(
          stream: _voucherService.getVoucherStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Text('No vouchers available.');
            }
            final voucherDocs = snapshot.data!.docs;
            final voucherData = voucherDocs.first.data() as Map<String, dynamic>;

          return Column(
            children: [
              Image.asset(
                ('assets/images/food2.jpg'),
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
                        child: Text(voucherData['name']),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text('Valid Until: ${voucherData['validUntil']}'),
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
                      Text('Details: ${voucherData['details']}'),
                      Padding(padding: EdgeInsets.only(top: screenHeight * 0.03)),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildAmountButton('-'),
                            Padding(padding: EdgeInsets.only(left: screenWidth * 0.05)),
                            Text('number'),
                            Padding(padding: EdgeInsets.only(left: screenWidth * 0.05)),
                            _buildAmountButton('+'),
                          ],
                        ),
                      ),
                      _buildToCartButton(voucherData),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAmountButton(String buttonText) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: () {

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
