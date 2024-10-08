import 'package:flutter/material.dart';
import 'package:project/utils/theme.dart';
import 'package:project/services/user_purchase.dart';
import 'package:project/views/staff/redeem_fail.dart';

class ScanVoucher extends StatefulWidget {
  const ScanVoucher({super.key});

  @override
  State<ScanVoucher> createState() => _ScanMemberState();
}

class _ScanMemberState extends State<ScanVoucher> {
  TextEditingController _voucherIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _scanQRCodeText(),
                  _buildVocuherIDTextField(),
                  _buildButton(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _scanQRCodeText() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30, top: 30),
      child: Text(
        'Enter User Voucher ID',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _buildButton() {
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
              onPressed: () async {
                String voucherID = _voucherIDController.text.trim().replaceAll(' ', '');
                if (voucherID.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Voucher ID cannot be empty.'),
                    ),
                  );
                } else {
                  try {
                    await UserPurchaseService()
                        .redeemVoucher(_voucherIDController.text);
                    Navigator.pushNamed(context, '/redeem-success');
                    _voucherIDController.clear();
                  } catch (e) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RedeemFail(errorMessage: e.toString()),
                      ),
                    );
                    _voucherIDController.clear();
                  }
                }
              },
              child: const Center(
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocuherIDTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _voucherIDController,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            labelText: 'User Voucher ID',
            labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppTheme.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a voucher iD.';
            }
            return null;
          }),
    );
  }
}
