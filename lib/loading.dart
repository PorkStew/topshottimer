import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
//loading screen for all views
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color> (Themes.PrimaryColorRed),
            strokeWidth: 5.0,
          ),
        ),
      ),
    );
  }
}
