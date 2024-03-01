import 'package:flutter/material.dart';
import 'package:project/theme.dart';


class AddPoint extends StatefulWidget {
  const AddPoint({super.key});

  @override
  State<AddPoint> createState() => _AddPointState();
}

class _AddPointState extends State<AddPoint> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: true,
      ),
      body:Center(child: Text("Add point page"),)
    );
  }
}