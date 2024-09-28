import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:project/utils/theme.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/LOGO.svg', 
                width: 150, 
                height: 150, 
              ),
              const SizedBox(height: 20), 
              const Text(
                'MILVERTON CLUB',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor
                ),
              ),
              Lottie.asset(
                'assets/animations/loading.json', 
                height: 150
              ),
            ],
          ),
      ),
    );
  }
}