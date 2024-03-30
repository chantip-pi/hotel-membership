import 'package:flutter/material.dart';
import 'package:project/services/user_service.dart';
import 'package:project/utils/theme.dart';
import 'package:project/utils/format_string.dart';

class AddPointSuccess extends StatefulWidget {
  const AddPointSuccess({super.key});

  @override
  State<AddPointSuccess> createState() => _AddPointSuccessState();
}

class _AddPointSuccessState extends State<AddPointSuccess> {

   late Future<Map<String, dynamic>?> _currentUserFuture;
  late String? name;
  late String? surname;
  late String? email;
  late String? phone;
  late String? memberID;
  late int? points;

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
         title: const Text("Continue",
        style: TextStyle(color: Colors.white,fontSize: 16)),
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
                                _memberSucess(),
                                _memberPointText(),
                                _memberInfo(
                                    title: 'Name-Surname',
                                    value: '$name $surname'),
                                _memberInfo(
                                    title: 'Member ID', value: FormatUtils.addSpaceToNumberString('$memberID')),
                                _memberInfo(title: 'Email', value: '$email'),
                                _memberInfo(title: 'Phone', value:  FormatUtils.formatPhoneNumber('$phone')),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text(
                            'User not found or error getting user details by ID');
                      }
                    }
                  },
                ),
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

  Widget _memberSucess() {
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
              'Succesfully Add Points!',
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