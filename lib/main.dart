import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/login.dart' as login;
import 'package:topshottimer/verifyEmail.dart' as verify;
import 'package:http/http.dart' as http;
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;


//TODO: verified for shared preferences
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
    //checks if shared preferences has user information and show a screen depending on that information
    checkUserInformation(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
          child: SizedBox(
          height: 100,
          width: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color> (Colors.red),
                strokeWidth: 5.0,
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

}
//acts like a auto login system that will check if shared preferences has user information and will show a screen depending on that information
checkUserInformation(context) async {
  //getting user information
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = await prefs.getString('id');
  String email = await prefs.getString('email');
  String hashedPassword = await prefs.getString('password');
  String verified = await prefs.get('verify');
  //checking that the shared preference information is not empty, then will try login
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
      //data is then received from the php file indicating user state
      Map<String, dynamic> data = json.decode(res.body);
      String id = data['id'];
      String status = data["status"];
      print("status: " + status);
      //not a user at all
      if (status == "notuser") {
        print("we don't have this user");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login.Login()));
      }
      //is a user but has not verified their email yet
      else if (status == "nonverified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'false');
        print("User ID: " + id);
        print("we have this user but they are not verified");
        Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
        //if details are correct and in the database then they can use the app.
      } else if (status == "verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'true');
        print("User ID: " + id);
        print("user details is all in order");
        Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      }
      //no shared preference data is found
    }else
      {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => login.Login()));
      }
}

