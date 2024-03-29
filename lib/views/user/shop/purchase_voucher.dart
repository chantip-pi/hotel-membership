
import 'package:flutter/material.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/utils/format_string.dart';
import 'package:project/models/cart.dart';
import 'package:provider/provider.dart';

class PurchaseVoucher extends StatefulWidget {
  final String voucherID;
  const PurchaseVoucher({Key? key, required this.voucherID}) : super(key: key);

  @override
  State<PurchaseVoucher> createState() => _PurchaseVoucherState();
}

class _PurchaseVoucherState extends State<PurchaseVoucher> {
  late var _voucher;
  int count = 1;

  @override
  void initState() {
    super.initState();
    _voucher = VoucherService().getVoucherByID(widget.voucherID);
  }

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      if (count > 1) {
        count--;
      }
    });
  }

  Widget _buildAmountButton(
    IconData iconData, Function() onPressed) {
    double screenWidth = MediaQuery.of(context).size.width;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        backgroundColor: Colors.white,
      ),
      child: Container(
        width: screenWidth * 0.05,
        height: screenWidth * 0.05,
        child: Center(child: Icon(iconData, color: Colors.black)),
      ),
    );
  }

  Widget _buildToCartButton(Map<String, dynamic> voucherData) {
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
                cart.addToCart(
                  widget.voucherID,
                  count
                 );
                 Navigator.pop(context);
              },
              child:  Center(
                child: Text(
                  "Add to cart ${(count * voucherData['points'])} Points",
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Purchase Voucher'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _voucher,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text(snapshot.toString());
          } else {
            final voucherData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    child: Image.network(
                      voucherData[
                          'imageUrl'], // Assuming 'image' is the URL of the voucher image
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.01)),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(voucherData['name']),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                              FormatUtils.formatDate(voucherData['timestamp'])),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02)),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02)),
                        Text(voucherData['termsCondition']),
                        Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.03)),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildAmountButton(Icons.remove, decrement),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.05)),
                              Text(count.toString()),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: screenWidth * 0.05)),
                              _buildAmountButton(Icons.add, increment),
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
          }
        },
      ),
    );
  }
}
