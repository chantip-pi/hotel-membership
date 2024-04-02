import 'package:flutter/material.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/format_string.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project/models/cart.dart';
import 'package:project/utils/theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _voucher,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  AppTheme.primaryColor,
                ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Text(snapshot.toString());
          } else {
            final voucherData = snapshot.data!.data() as Map<String, dynamic>;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildImageSection(voucherData),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildNameSection(voucherData),
                        buildDetailsSection(voucherData),
                      ],
                    ),
                  ),
                ),
                buildAmountControlSection(),
                buildToCartButton(voucherData),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildImageSection(Map<String, dynamic> voucherData) {
    return ClipRRect(
      child: Image.network(
        voucherData['imageUrl'],
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildNameSection(Map<String, dynamic> voucherData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Center(
        child: Text(
          voucherData['name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildDetailsSection(Map<String, dynamic> voucherData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Valid Until ${FormatUtils.formatDate(voucherData['dueDate'])}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const Text(
            "Terms & Conditions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: buildBulletPoints(voucherData['termsCondition']),
          ),
        ],
      ),
    );
  }

  Widget buildBulletPoints(String termsCondition) {
    final bulletPoints = termsCondition.split('-');
    if (bulletPoints.isNotEmpty) {
      bulletPoints.removeAt(0);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bulletPoints.map((bulletPoint) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '• ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Text(
                  bulletPoint.trim(),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildAmountControlSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.end, // Align the row to the end (right)
        children: [
          IconButton(
            onPressed: decrement,
            icon: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.black,
            ),
          ),
          SizedBox(
            width: 80,
            child: Center(
              child: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: increment,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              padding: EdgeInsets.all(10),
              backgroundColor: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToCartButton(Map<String, dynamic> voucherData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  count,
                );
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  "Add to Cart ${(count * voucherData['points'])} Points",
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
