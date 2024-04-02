import 'package:flutter/material.dart';
import 'package:project/utils/theme.dart';


class RedeemFail extends StatefulWidget {
  const RedeemFail({super.key});

  @override
  State<RedeemFail> createState() => _RedeemFailState();
}

class _RedeemFailState extends State<RedeemFail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: AppTheme.backgroundColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Icon(
                          Icons.block_rounded,
                          color: Colors.red,
                          size: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ),
                      const Center(
                        child: Text(
                          'No voucher found. Please try again',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
