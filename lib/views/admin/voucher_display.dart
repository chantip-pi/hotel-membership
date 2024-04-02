import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/services/voucher_service.dart';
import 'package:project/utils/format_string.dart';
import 'package:project/utils/loading_page.dart';

class VoucherDisplay extends StatefulWidget {
  final String voucherID;

  const VoucherDisplay({Key? key, required this.voucherID}) : super(key: key);

  @override
  State<VoucherDisplay> createState() => _VoucherDisplayState();
}


class _VoucherDisplayState extends State<VoucherDisplay> {
  late var _voucher;

   @override
  void initState() {
    super.initState();
    _voucher = VoucherService().getVoucherByID(widget.voucherID);
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
            return const LoadingPage();
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
}
