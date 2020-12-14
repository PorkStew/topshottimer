import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'dart:convert';
import 'package:topshottimer/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:topshottimer/Views/PageSelector.dart';
import 'package:topshottimer/Views/LoginSignUp/login.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPasswordConfirm.dart';
import 'package:topshottimer/Views/LoginSignUp/verifyEmail.dart';

//TODO: check shared preferences and the naming
//TODO: add a loading screen to the sign up when going to verifyemail
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Shot Timer',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: CheckUserDetails(),
      debugShowCheckedModeBanner: false,
      //tells the system the locations for views that are accessed through pushReplacementNamed
      routes: {
        '/LoginSignUp/login': (context) => Login(),
        '/PageSelector': (context) => pageSelector(),
        '/LoginSignUp/resetPasswordConfirm': (context) => ResetPasswordConfirm(),
        '/LoginSignUp/verifyEmail': (context) => verifyEmail(),
      },
    );
  }
}

class CheckUserDetails extends StatefulWidget {
  @override
  _CheckUserDetailsState createState() => _CheckUserDetailsState();
}

class _CheckUserDetailsState extends State<CheckUserDetails> {
  //variable declaration
  bool _loading = true;
  @override
  void initState() {
    //checks if shared preferences has user information and show a screen depending on that information while verifying
    //the information
    checkUserInformation(context);
    super.initState();
  }
  //loading screen
  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Container();
  }
}
//acts like a auto login system that will check if shared preferences has user information and will show a screen depending on that information
checkUserInformation(context) async {
  //get user information
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('id');
  String email =  prefs.getString('email');
  String hashedPassword = prefs.getString('password');
  String verified = prefs.getString('verify');

  //checks the validity shared preference information is not empty, then will try login
    if(id != null && email != null && hashedPassword != null && verified != null) {
      var url = 'https://www.topshottimer.co.za/login.php';
      var res = await post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user shared preferences
            "emailAddress": email,
            "password": hashedPassword,
          }
      );

      //data is then received from the php file indicating user state
      //status can either be verified / non-verified or not-user
      Map<String, dynamic> data = json.decode(res.body);
      String id = data['id'];
      String status = data["status"];
      //not a user
      if (status == "not-user") {
        Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
      }
      //is a user but has not verified their email yet
      else if (status == "non-verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'false');
        Navigator.pushReplacementNamed(context, '/LoginSignUp/verifyEmail', arguments: {'email': email});
        //if details are in the database and user email is verified
      } else if (status == "verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'true');
        Navigator.pushReplacementNamed(context, '/PageSelector');
      }
      //no shared preference data is found go to login
    } else{
      Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
    }
}

