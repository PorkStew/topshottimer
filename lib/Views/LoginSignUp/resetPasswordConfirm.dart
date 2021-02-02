import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/LoginSignUp/login.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPassword.dart';
import 'package:topshottimer/loading.dart';

class ResetPasswordConfirm extends StatefulWidget {
  _ResetPasswordConfirmState createState() => _ResetPasswordConfirmState();
}

class _ResetPasswordConfirmState extends State<ResetPasswordConfirm> {
  bool loading = false;
  BuildContext context;

  //resetPassword(arguments['email']);
  @override
  void initState(){
    super.initState();
    resetPassword();
    print("HERE");
    //print(arguments['email']);
  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return loading? Loading() : Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50, bottom: 15, left: 0, right: 0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                      child: Image.asset(
                        "assets/padlock@3x.png",
                        width: 130,
                      )),
                ),
                Text("Password Reset", textAlign: TextAlign.center, style:  TextStyle(
                    fontSize: 30, color: Themes.darkButton2Color
                ),),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "A reset link has been sent to ",
                              style: TextStyle(color: Colors.grey, fontSize: 17)),
                          TextSpan(
                              text: arguments['email'],
                              recognizer: new TapGestureRecognizer()..onTap = () => print('Tap Here onTap'),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          TextSpan(
                              text: " follow the instructions to successfully reset your password",
                              style: TextStyle(color: Colors.grey, fontSize: 17)),
                        ]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 2),
                  child: Column(
                    children: [
                      RichText(
                          text: TextSpan(
                              text: "Wrong email address?",
                              style: TextStyle(color: Themes.darkButton2Color, fontSize: 15),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () {
                                  print("wrong email!!!");

                                  //tests();
                                  //return to sign up because they entered the wrong information
                                  setState(() => loading = true);
                                  //setUserPreferencesNull();
                                  Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => ResetPassword(arguments['email'])));
                                  //getUserInfo();
                                }
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
            ),
            Container(

              child: Column(
                children: [
                  SizedBox(
                      width: 268,
                      height: 60,
                      child: RaisedButton(
                        onPressed: (){
                          print("return to login please!");
                          //checkUserVerified();

                          Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
                        },
                        child: Text(
                          'Login',
                           style: TextStyle(color: Colors.white , fontSize: 20),
                        ),
                        color: Themes.darkButton1Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                      width: 268,
                      height: 60,
                      child: RaisedButton(
                        onPressed: (){
                          print("HELO CONFIRM FOR ME PEASE");
                          resetPassword();
                          //checkUserVerified();
                          //Navigator.push(context,
                              //MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Resend Email',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Themes.darkButton2Color,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )
                  ),
                ],
              ),
            ),
            Expanded(child:
            Align(
              alignment: Alignment.bottomCenter,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(color: Colors.white)),
                  TextSpan(
                      text: " Login",
                      recognizer: new TapGestureRecognizer()..onTap = () =>
                      {
                      print("wrong email!!!"),
                       
                      //tests();
                      //return to sign up because they entered the wrong information
                      setState(() => loading = true),
                //setUserPreferencesNull()
                      Navigator.pushReplacementNamed(context, '/LoginSignUp/login')
                      },
                      style: TextStyle(
                          color: Themes.darkButton2Color,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
            )),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
  Future resetPassword() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    print(email);
    try{
      var url = 'https://www.topshottimer.co.za/resetPasswordMailer.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "emailAddress": email,
          }
      );
      Map<String, dynamic> data = json.decode(res.body);
      String status = data["success"];
      print(status);
      if(status == 'true'){
        print("EMAIL SENT SUCCESSFULY");
      } else if(status == 'false'){
        print("EMAIL WAS NOT SENT DUE TO ERROR");
      }
    }catch (error) {
      print(error.toString());
      setState(() => loading = false);
    }
  }
}
