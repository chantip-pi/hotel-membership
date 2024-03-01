import 'package:flutter/material.dart';
import 'package:project/theme.dart';

class StaffRedeem extends StatefulWidget {
  const StaffRedeem({super.key});

  @override
  State<StaffRedeem> createState() => _StaffRedeemState();
}

class _StaffRedeemState extends State<StaffRedeem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body:Center(child: Text("redeem page"),)
    );
  }
}