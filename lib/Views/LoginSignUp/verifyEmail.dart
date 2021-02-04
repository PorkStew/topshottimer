import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:topshottimer/Views/LoginSignUp/signup.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:topshottimer/Views/LoginSignUp/login.dart' as login;
import 'package:http/http.dart' as http;
import 'package:topshottimer/loading.dart';
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
    print("VERIFYEMAIL.DART");
    getUserInfo();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => areTheyVerified());
  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return loading? Loading() :  Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 80, bottom: 15, left: 0, right: 0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color> (Themes.darkButton2Color),
                        strokeWidth: 5.0,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text("$test", textAlign: TextAlign.center, style:  TextStyle(
                        fontSize: 30, color: Themes.darkButton2Color, fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2
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
                padding: EdgeInsets.only(top: 90, bottom: 0, left: 0, right: 0),
                child: Column(
                  children: [
                    SizedBox(
                        width: 268,
                        height: 61,
                       child: ElevatedButton(
                          onPressed: (){
                            print("resending email to user!");
                            //checkUserVerified();
                            getUserInfo();
                            emailSent();
                          },
                          child: Text(
                              'Resend Email',
                            style: TextStyle(fontSize: 20, color: Colors.white       ),
                          ),
                         style: ElevatedButton.styleFrom(primary: Themes.darkButton1Color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
                        //setState(() => loading = true),
                          nullPreferences(),
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
  nullPreferences()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  tests() async{
    await Future.delayed(const Duration(seconds: 1), (){});
    setState(() {
      test = "Updating Account";
    });
    await Future.delayed(const Duration(seconds: 3), (){});
    setState(() {
      test = "Verifying Account";
    });
    await Future.delayed(const Duration(seconds: 5), (){});
    setState(() {
      test = "Verification Complete";
    });
    await Future.delayed(const Duration(seconds: 2), (){});
    setState(() {
      timer.cancel();
      Navigator.pushReplacementNamed(context, '/PageSelector');
    });
    //super.dispose();
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
        await prefs.setBool('loginBefore', true);
        //saveUserInformation(id, email, hashedPassword);
        //setState(() => loading = true);
        tests();
        //timer.cancel();
        //super.dispose();
      } else{

      }
      //RELOAD PAGE TO RESEND EMAIL
      } on TimeoutException catch (e) {
        print('Timeout Error: $e');
      } on Socket catch (e) {
        print('Socket Error: $e');
      } on Error catch (e) {
        print('General Error: $e');
      }
  }
  //this called auto on page loador when user clicks button
  Future getUserInfo() async {
    // final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    print("Sending email!!!");
    //check if user is verified or send email verification link
    //print("should call send user verify email");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    print(email);
    print("************************");
    try {
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
      if (status == 'true') {
        print("EMAIL SENT SUCCESSFULY");
      } else if (status == 'false') {
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
  emailSent(){
    Dialog dialog = new Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 140,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Verification Email Sent!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 20,),
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
                                BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Confirm",
                                    style: TextStyle(fontSize: 20)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Themes.darkButton2Color,
                    radius: 40,
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}


