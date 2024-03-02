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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool userNotFound = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // get member ID from Previous Scan page
    final dynamic receivedMemberID = ModalRoute.of(context)!.settings.arguments;

    _currentUserFuture = UserService().getUserByMemberId(receivedMemberID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
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
                FutureBuilder<Map<String, dynamic>?>(
                  future: _currentUserFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Display a circular loading indicator while fetching data
                      return const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor));
                    } else if (snapshot.hasError) {
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
                                _memberInfo(
                                    title: 'Name-Surname',
                                    value: '$name $surname'),
                                _memberInfo(
                                    title: 'Member ID', value: '$memberID'),
                                _memberInfo(title: 'Email', value: '$email'),
                                _memberInfo(title: 'Phone', value: '$phone'),
                              ],
                            ),
                          ),
                        );
                      } else {
                       return _userNotFoundDisplay();
                      }
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildAddPointTextField(),
                      _buildButton(),
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

  Widget _memberPointText() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 30),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
          const Divider(
            color: AppTheme.primaryColor,
            thickness: 1.0,
          ),
        ],
      ),
    );
  }

  Widget _buildAddPointTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Form(
        key: _formKey,
        child: TextFormField(
            autofocus: true,
            controller: _addPointController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Enter Points',
              labelStyle: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 10),
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
                return 'Please enter a number.';
              }
              final RegExp numberRegex = RegExp(r'^[0-9]+$');
              if (!numberRegex.hasMatch(value)) {
                return 'Invalid input. Please enter a valid number.';
              }
              return null;
            }),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
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
                if (_formKey.currentState?.validate() ?? false) {
                  int additionalPoints = int.parse(_addPointController.text);
                  await _updateUserPoints(additionalPoints, '$memberID');
                  _addPointController.clear();
                  Navigator.pushReplacementNamed(context, '/add-point-success',arguments: memberID);
                }
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

  Future<void> _updateUserPoints(int additionalPoints, String memberID) async {
    try {
      // Fetch the current user data again to ensure it's up-to-date
      Map<String, dynamic>? currentUser =
          await UserService().getUserByMemberId(memberID);

      // Update the points
      int updatedPoints = (currentUser?['points'] ?? 0) + additionalPoints;
      await UserService().updateUserPoints(memberID, updatedPoints);

    } catch (error) {
      print('Error updating points: $error');
    }
  }

    Widget _userNotFoundDisplay() {
    return  Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                'No member found. Please try again',
                style: TextStyle(
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


}
