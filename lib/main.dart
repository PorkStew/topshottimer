import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/login.dart' as login;
import 'package:topshottimer/Views/timer.dart' as TimerPage;
import 'package:topshottimer/verifyEmail.dart' as verify;
import 'package:http/http.dart' as http;

import 'Views/PageSelector.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //root widget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Top Shot Timer',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: checkUser(),
    );
  }
}


class checkUser extends StatefulWidget {
  @override
  _checkUserState createState() => _checkUserState();
}

class _checkUserState extends State<checkUser> {
  @override
  void initState() {
    checkUserDetails(context);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
  checkUserDetails(context) async{
        updateData(context);
  }


updateData(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = await prefs.getString('id');
  String email = await prefs.getString('email');
  String hashedPassword = await prefs.getString('password');
    if(id != null && email != null && hashedPassword != null) {
      var url = 'https://www.topshottimer.co.za/login.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user defaults
            "emailAddress": email,
            "password": hashedPassword,
          }
      );
      Map<String, dynamic> data = json.decode(res.body);
      String id = data['id'];
      String status = data["status"];
      await prefs.setString('id', id);
      print("status: " + status);
      if (status == "notuser") {
        print("we don't have this user");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login.Login()));
      }
      else if (status == "nonverified" && id != null) {
        print("User ID: " + id);
        print("we have this user but they are not verified");
        Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
      } else if (status == "verified" && id != null) {
        print("User ID: " + id);
        print("user details is all in order");
        Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
      }
    }else
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login.Login()));
      }
}

