import 'package:flutter/material.dart';
import 'package:project/theme.dart';

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
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body:Center(
        child: 
      Column(
        children: [
          Text("Scan member"),
          _buildMemberIDTextField(),
          _buildButton()
        ],
      ),
      )
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
                    MaterialStateProperty.all<Color>(AppTheme.primaryColor),
                fixedSize: MaterialStateProperty.all<Size>(
                  const Size.fromHeight(56),
                ),
              ),
              onPressed: () async {
              Navigator.pushNamed(context, '/add-point', arguments: _memberIDController.text);
              },
              child: const Center(
                child: Text(
                  'Scan',
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
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'memberID',
            labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
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

 