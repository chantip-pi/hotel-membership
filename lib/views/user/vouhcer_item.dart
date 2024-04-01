import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project/utils/format_string.dart';
import 'package:project/utils/theme.dart';

class VoucherItem extends StatefulWidget {
  final Map<String, dynamic> voucherInfo;
  final String purchaseID;

  const VoucherItem(
      {Key? key, required this.voucherInfo, required this.purchaseID})
      : super(key: key);

  @override
  _VoucherItemState createState() => _VoucherItemState();
}

class _VoucherItemState extends State<VoucherItem> {
  bool _isChecked = false;
  List<String> bulletPoints = [];
  @override
  Widget build(BuildContext context) {
    bulletPoints = widget.voucherInfo['termsCondition'].split('-');
    if (bulletPoints.isNotEmpty) {
      bulletPoints.removeAt(0);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detail",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildImageSection(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildNameSection(),
                  buildDetailsSection(),
                ],
              ),
            ),
          ),
          buildAgreementSection(),
          buildRedeemButtonSection(),
        ],
      ),
    );
  }

  Widget buildImageSection() {
    return Expanded(
      flex: 1,
      child: ClipRRect(
        child: Image.network(
          widget.voucherInfo['imageUrl'],
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget buildNameSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Center(
        child: Text(
          widget.voucherInfo['name'],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Valid Until ${FormatUtils.formatDate(widget.voucherInfo['dueDate'])}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const Text(
            "Terms & Conditions",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          buildBulletPoints(bulletPoints),
        ],
      ),
    );
  }

  Widget buildBulletPoints(List<String> bulletPoints) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: bulletPoints.map((bulletPoint) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '• ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                bulletPoint,
                style: TextStyle(
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


  Widget buildAgreementSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Checkbox(
            activeColor: AppTheme.primaryColor,
            value: _isChecked,
            onChanged: (newValue) {
              setState(() {
                _isChecked = newValue ?? false;
              });
            },
          ),
          const Flexible(
            child: Text(
              'I agree to all the terms and conditions of usage.',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRedeemButtonSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isChecked
                  ? () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                                'Please Present this code to the staff'),
                            content: Text(widget.purchaseID),
                            backgroundColor: Colors.white,
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, '/my-voucher');
                                },
                                child: const Text(
                                  'Back',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  : null,
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.black;
                  },
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              child: const Text(
                "Redeem",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
