import 'package:flutter/material.dart';
import 'package:project/utils/theme.dart';


class RedeemSuccess extends StatefulWidget {
  const RedeemSuccess({super.key});

  @override
  State<RedeemSuccess> createState() => _RedeemSuccessState();
}

class _RedeemSuccessState extends State<RedeemSuccess> {

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Continue",style: TextStyle(color: Colors.white),),
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
                _Success(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildButton()
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _Success() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Icon(
              Icons.check_circle,
              color: Colors.lightGreen, 
              size: MediaQuery.of(context).size.height * 0.1, 
            ),
          Center(
            child: Text(
              'Succesfully Redeem Voucher',
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ],
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
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              onPressed: () {
              Navigator.pushNamed(context, '/staff-home-page');
              },
              child: const Center(
                child: Text(
                  'Back to Home Page',
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

}