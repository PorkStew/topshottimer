import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:topshottimer/Views/LoginSignUp/verifyEmail.dart' as verify;
import 'package:topshottimer/Views/LoginSignUp/login.dart' as login;
import 'package:topshottimer/Views/LoginSignUp/resetPasswordConfirm.dart' as resetPasswordConfirm;
import 'package:topshottimer/Views/LoginSignUp/verifyEmail.dart' as verifyEmail;
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/loading.dart';

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
      home: checkUserDetails(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/LoginSignUp/login': (context) => login.Login(),
        '/PageSelector': (context) => pageSelector.pageSelector(),
        '/LoginSignUp/resetPasswordConfirm': (context) => resetPasswordConfirm.resetPasswordConfirm(),
        '/LoginSignUp/verifyEmail': (context) => verifyEmail.verifyEmail(),
        /*Here's where you receive your routes, and it is also the main widget*/
      },
    );
  }
}

class checkUserDetails extends StatefulWidget {
  @override
  _checkUserDetailsState createState() => _checkUserDetailsState();
}

class _checkUserDetailsState extends State<checkUserDetails> {
  bool loading = true;
  @override
  void initState() {
    //checks if shared preferences has user information and show a screen depending on that information
    //setState(() => loading() =true);
    checkUserInformation(context);
    super.initState();
  }
  //loading screen
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Container();
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

  //checking that the shared preference information is not empty, then will try login
    if(id != null && email != null && hashedPassword != null && verified != null) {
      var url = 'https://www.topshottimer.co.za/login.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user defaults
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
        print("da fuck");
        //Navigator.push(context, MaterialPageRoute(builder: (context) => login.Login()));
        Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
      }
      //is a user but has not verified their email yet
      else if (status == "non-verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'false');
        //Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail(email)));
        Navigator.pushReplacementNamed(context, '/LoginSignUp/verifyEmail', arguments: {'email': email});
        //if details are in the database and user account is verified
      } else if (status == "verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'true');
        //Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
        Navigator.pushReplacementNamed(context, '/PageSelector');
      }
      //no shared preference data is found go to login
    } else{
      //Navigator.push(context, MaterialPageRoute(builder: (context) => login.Login()));
      Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
    }
}

