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
  late String? memberID;
  late int? points;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access the context here
    final dynamic receivedData =
        ModalRoute.of(context)!.settings.arguments;

    // Initialize the future in the didChangeDependencies method
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
      body: Center(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _currentUserFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a circular loading indicator while fetching data
              return CircularProgressIndicator();
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
                memberID = currentUser['memberID'] as String?;
                points = currentUser['points'] as int?;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add point page member ID ${memberID}"),
                    Text("name: ${name}"),
                  ],
                );
              } else {
                // User not found or error getting user details by ID
                return Text('User not found or error getting user details by ID');
              }
            }
          },
        ),
      ),
    );
  }
}
