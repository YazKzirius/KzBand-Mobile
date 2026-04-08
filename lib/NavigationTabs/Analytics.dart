import 'package:flutter/material.dart';

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF060E13),
      body: Center(
        child: Text(
          "Analytics Coming Soon",
          style: TextStyle(
            color: Colors.white30,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}