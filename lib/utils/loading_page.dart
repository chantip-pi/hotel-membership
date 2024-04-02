import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/utils/theme.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
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
          const SizedBox(height: 40), 
         LoadingIndicator(),
        ],
      ),
    );
  }
}

class LoadingIndicator extends StatefulWidget {
  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    )..repeat(); // Start and repeat the animation
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller when not needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(
        Icons.refresh, // You can use any desired icon here
        size: 30,
        color: Theme.of(context).primaryColor, // Use the primary color from the theme
      ),
    );
  }
}