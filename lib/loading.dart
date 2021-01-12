import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
//loading screen for all views
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //onWillPop will prevent the user from interacting with the loading screen so that they can't go back to other views
    return WillPopScope(
      onWillPop: ()async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Center(
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
