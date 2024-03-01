import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/theme.dart';

class StaffHomePage extends StatelessWidget {
  const StaffHomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        color: AppTheme.backgroundColor,
        height: screenHeight,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: StaffButton(
                  iconPath: 'assets/icons/qr.svg',
                  label: 'ADD POINT',
                  routeName: '/scan-member',
                ),
              ),
              Expanded(
                child: StaffButton(
                  iconPath: 'assets/icons/Ticket_use_light.svg',
                  label: 'REDEEM',
                  routeName: '/staff-redeem',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StaffButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final String routeName;

  const StaffButton({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.routeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.secondaryColor,
            borderRadius: BorderRadius.circular(15.0),
          ),
          height: screenHeight * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                height: screenHeight * 0.1,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
