import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPassword.dart';
import 'package:topshottimer/Views/LoginSignUp/signup.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:topshottimer/Views/LoginSignUp/login.dart' as login;
import 'package:http/http.dart' as http;
import 'package:topshottimer/loading.dart';
//TODO WHAT SOULD WE DO IF THEY VERIFY AND ARE STILL ON THIS PAGE SHOULD WE CHECK
//TODO can still get email if verified issue issue
//TODO password cant be less than 6
class verifyEmail extends StatefulWidget {

  @override
  _verifyEmailState createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  //variable declaration
  int _count = 0;
  Timer timer;
  bool loading = false;
  String test = "Awaiting Verification";
  @override
  void initState(){
    super.initState();
    //check if user is verified or send email verification link
    getUserInfo();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => areTheyVerified());
    //timer?.cancel();
    //super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return loading? Loading() :  Scaffold(
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
                            "assets/mail-icon@3x.png",
                            width: 140,
                          )),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text("$test", textAlign: TextAlign.center, style:  TextStyle(
                        fontSize: 30
                    ),),
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: "A verification link has been sent to ",
                                  style: TextStyle(color: Colors.grey, fontSize: 17)),
                              TextSpan(
                                  text: arguments['email'],
                                  recognizer: new TapGestureRecognizer()..onTap = () => print('Tap Here onTap'),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold, fontSize: 17)),
                              TextSpan(
                                  text: " follow the instructions to complete your account setup.",
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
                                      setUserPreferencesNull();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => login.Login()));
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp(arguments['email'])));
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
                padding: EdgeInsets.only(top: 50, bottom: 15, left: 0, right: 0),
                child: Column(
                  children: [
                    SizedBox(
                        width: 268,
                        height: 61,
                       child: RaisedButton(
                          onPressed: (){
                            print("resending email to user!");
                            //checkUserVerified();
                            getUserInfo();
                          },
                          child: Text(
                              'Resend Email',
                            style: TextStyle(fontSize: 20, color: Colors.white       ),

                          ),
                          color: Themes.darkButton1Color,
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
                        setState(() => loading = true),
                          setUserPreferencesNull(),
                          Navigator.pushReplacementNamed(context, '/LoginSignUp/login'),
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
        )
    );
  }
  setUserPreferencesNull() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', null);
    await prefs.setString('email', null);
    await prefs.setString('password', null);
    await prefs.setString('verify', null);
    await prefs.setString('firstName', null);
    await prefs.setString('lastName', null);
  }
  tests() async{
    setState(() {
      test = "Checking Magazine";
    });
    await Future.delayed(const Duration(seconds: 5), (){});
    setState(() {
      test = "Loading Bullets";
    });
    await Future.delayed(const Duration(seconds: 5), (){});
    setState(() {
      test = "Locked & Loaded";
    });
    await Future.delayed(const Duration(seconds: 2), (){});
  }
  areTheyVerified() async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String email = await prefs.getString('email');
      String password = await prefs.getString('password');
      String verified = await prefs.getString('verify');
      if(verified == 'true'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      }
      try{
      var url = 'https://www.topshottimer.co.za/checkUserIsVerified.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user defaults
            "emailAddress": email,
            "password": password,
          }
      );
      Map<String, dynamic> data = json.decode(res.body);
      //String id = data['id'];
      String status = data["verified"];
      //display message because they are not a user
      if (status == "error") {
        print("error");
        setState(() => loading = true);
        timer.cancel();
        super.dispose();
        //TODO should we not just return to login if there is no user
        //return to login but also display error before or after they get to login page
        Navigator.push(context, MaterialPageRoute(builder: (context) => login.Login()));
      }
      //is a user but they haven't verified their email address
      else if (status == "non-verified") {
        //await prefs.setString('verify', "non-verified");

      }
      //is a user and is veried email so they can use the app
      else if (status == "verified") {
        await prefs.setString('verify', "verified");
        //saveUserInformation(id, email, hashedPassword);
        setState(() => loading = true);
        timer.cancel();
        super.dispose();
        Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      } else{

      }
      } on TimeoutException catch (e) {
        print('Timeout Error: $e');
      } on Socket catch (e) {
        print('Socket Error: $e');
      } on Error catch (e) {
        print('General Error: $e');
      }
  }
  //this called auto on page loador when user clicks button
  getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    print(email);
    try{
      var url = 'https://www.topshottimer.co.za/createAccountVerifyEmailMailer.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //TODO uncomment when testing is complete
            "emailAddress": email,
          }
      );
      //MAYBE WE NEED THIS?????
      Map<String, dynamic> data = json.decode(res.body);
      String status = data["success"];
      print(status);
      //TODO show that message was sent successfully
      if(status == 'true'){
        print("EMAIL SENT SUCCESSFULY");
      } else if(status == 'false'){
        print("EMAIL WAS NOT SENT DUE TO ERROR");
      }
      // if(status == "non-verified" && _count != 0) {
      //   emailSent();
      // }
      _count++;
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }
  //delete
  emailSent(){
    SimpleDialog carDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Email Sent!", style: TextStyle(fontSize: 20),),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight:  Radius.circular(6)),
                        color: Themes.darkButton2Color,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("OKAY",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    showDialog(context: context, builder: (context) => carDialog);
  }
  //delete
  notVerifiedError(){
    SimpleDialog carDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Account not verified!", style: TextStyle(fontSize: 20),),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight:  Radius.circular(6)),
                        color: Colors.red,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("TRY AGAIN",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      getUserInfo();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(6)),
                        color: Colors.blueAccent,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("SEND EMAIL",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    showDialog(context: context, builder: (context) => carDialog);
  }
}


