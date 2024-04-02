import 'package:flutter/material.dart';
import 'package:project/utils/theme.dart';

class ScanMember extends StatefulWidget {
  const ScanMember({super.key});

  @override
  State<ScanMember> createState() => _ScanMemberState();
}

class _ScanMemberState extends State<ScanMember> {
  TextEditingController _memberIDController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body:SingleChildScrollView(
        child: Center(
          child: 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              _scanQRCodeText(),
              _buildMemberIDTextField(),
              _buildButton()
            ],
          ),
        ),
        ),
      )
    );
  }

Widget _scanQRCodeText(){
    return  Padding(
      padding: EdgeInsets.only(bottom: 30, top: 30),
      child: Text(
        'Enter Member ID',
        style: const TextStyle(
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
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.black),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              onPressed: () {
              Navigator.pushNamed(context, '/add-point', arguments: _memberIDController.text);
              _memberIDController.clear();
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


  Widget _buildMemberIDTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _memberIDController,
          cursorColor: Colors.black,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Member ID',
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
              return 'Please enter a member ID.';
            }
            return null;
          }),
    );
  }

}

 