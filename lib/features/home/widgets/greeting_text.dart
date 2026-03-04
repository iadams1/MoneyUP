import 'package:flutter/material.dart';

class GreetingText extends StatelessWidget {
  final TextStyle? style;

  const GreetingText({super.key, this.style});

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 12) {
      return "Good Morning,";
    } else if (hour >= 12 && hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _getGreeting(),
      style: style,
    );
  }
}