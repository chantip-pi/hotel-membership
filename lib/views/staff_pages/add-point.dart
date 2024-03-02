import 'package:flutter/material.dart';
import 'package:project/services/user_service.dart';
import 'package:project/theme.dart';


class AddPoint extends StatefulWidget {
  const AddPoint({super.key});

  @override
  State<AddPoint> createState() => _AddPointState();
}
class _AddPointState extends State<AddPoint> {
  late Future<Map<String, dynamic>?> _currentUserFuture;
  late String? name;
  late String? surname;
  late String? email;
  late String? phone;
  late String? memberID;
  late int? points;

  TextEditingController _addPointController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the context here
    final dynamic receivedData =
        ModalRoute.of(context)!.settings.arguments;

    _currentUserFuture =
        UserService().getUserByMemberId(receivedData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<Map<String, dynamic>?>(
            future: _currentUserFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Display a circular loading indicator while fetching data
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Display an error message if there is an error
                return Text('Error: ${snapshot.error}');
              } else {
                // Data has been successfully fetched
                Map<String, dynamic>? currentUser = snapshot.data;
        
                if (currentUser != null) {
                  // Successfully retrieved user details by ID
                  name = currentUser['name'] as String?;
                  surname = currentUser['surname'] as String?;
                  email = currentUser['email'] as String?;
                  phone = currentUser['phone'] as String?;
                  memberID = currentUser['memberID'] as String?;
                  points = currentUser['points'] as int?;
        
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        _memberPointText(),
                        _memberInfo(title: 'Name-Surname',value: '$name $surname'),
                        _memberInfo(title: 'Member ID', value: '$memberID'),
                        _memberInfo(title: 'Email', value: '$email'),
                        _memberInfo(title: 'Phone', value: '$phone'),
                        _buildAddPointTextField(),
                        _buildButton()
                        ],
                      ),
                    ),
                  );
                } else {
                  // User not found or error getting user details by ID
                  return const Text('User not found or error getting user details by ID');
                }
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _memberPointText(){
    return  Padding(
      padding: EdgeInsets.only(bottom: 30, top: 30),
      child: Text(
        '${points.toString()} Points',
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Colors.black,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget _memberInfo({required String title, required String value}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
      Divider(
        color: AppTheme.primaryColor,
        thickness: 1.0,
      ),
    ],
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
              null;
              },
              child: const Center(
                child: Text(
                  'Add',
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


  Widget _buildAddPointTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
          controller: _addPointController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Enter amount of points',
            labelStyle: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
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
