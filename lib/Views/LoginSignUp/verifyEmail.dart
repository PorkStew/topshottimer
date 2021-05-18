import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:topshottimer/Views/LoginSignUp/signup.dart';
import 'package:topshottimer/Views/LoginSignUp/login.dart';
import 'package:http/http.dart';
import 'package:topshottimer/global.dart';
import 'package:topshottimer/loading.dart';
import 'package:get/get.dart';
import 'package:topshottimer/Views/Subscription/pricing.dart';

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  //variable declaration
  Timer _timer;
  bool _loading = false;
  final _controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    getUserInfo();
    //check if user verifies email every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) => areTheyVerified());
  }
  //main view area
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return _loading
        ? Loading()
        : Scaffold(
            body: Center(
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(top: 80, bottom: 15, left: 0, right: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Themes.darkButton2Color),
                          strokeWidth: 5.0,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        "Awaiting Verification",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(25),
                        child: Column(
                          children: [
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "A verification link has been sent to ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Colors.grey)),
                                TextSpan(
                                    text: arguments['email'],
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () => print('Tap Here onTap'),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Theme.of(context).dividerColor)),
                                TextSpan(
                                    text:
                                        " follow the instructions to complete your account setup.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 17,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Colors.grey)),
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
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Themes.darkButton2Color),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        print("wrong email!!!");
                                        //return to sign up because they entered the wrong information
                                        setState(() => _loading = true);
                                        Get.off(() => Login());
                                        Get.to(SignUp(arguments['email']));
                                      })),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 90, bottom: 0, left: 0, right: 0),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 268,
                        height: 61,
                        child: Obx(() => ElevatedButton(
                              onPressed: _controller.btnState.value
                                  ? () => resendEmailProcess()
                                  : null,
                              child: Text(
                                'Resend Email',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontFamily: 'Montserrat-Regular',
                                    letterSpacing: 0.2,
                                    color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Themes.darkButton1Color,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            )),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: "Already have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              fontFamily: 'Montserrat-Regular',
                              letterSpacing: 0.2,
                              color: Theme.of(context).dividerColor)),
                      TextSpan(
                        text: " Login",
                        recognizer: new TapGestureRecognizer()
                          ..onTap = () => {
                                //setState(() => loading = true),
                                nullPreferences(),
                                Navigator.pushReplacementNamed(
                                    context, '/LoginSignUp/login'),
                              },
                        style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Regular',
                            letterSpacing: 0.2,
                            color: Themes.darkButton2Color),
                      ),
                    ]),
                  ),
                )),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ));
  }
  //called when user wants another email sent to them
  resendEmailProcess() {
    print("resending email to user!");
    getUserInfo();
    emailSent();
  }
  //when user wants to go back to login set SharedPreferences to null
  nullPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  //called automatically by timer to check if user verifies account and the value of verification within the database changes
  areTheyVerified() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    String password = await prefs.getString('password');
    String verified = await prefs.getString('verify');
    if (verified == 'true') {
      Get.off(() => pricing(), arguments: {'pop': false});
    }
    try {
      var url = 'https://www.topshottimer.co.za/checkUserIsVerified.php';
      var res = await post(Uri.parse(url), headers: {
        "Accept": "application/jason"
      }, body: {
        //get this information from user defaults
        "emailAddress": email,
        "password": password,
      });
      Map<String, dynamic> data = json.decode(res.body);
      String status = data["verified"];
      //display message because they are not a user
      if (status == "error") {
        print("error");
        setState(() => _loading = true);
        _timer.cancel();
        super.dispose();
        //Navigator.push(
          //  context, MaterialPageRoute(builder: (context) => Login()));
        Get.off(() => Login());
      }
      //is a user but they haven't verified their email address
      else if (status == "non-verified") {
        return;
      }
      //is a user and is verified email so they can use the app
      else if (status == "verified") {
        await prefs.setString('verify', "verified");
        await prefs.setBool('loginBefore', true);
        _timer.cancel();
        Get.off(() => pricing(), arguments: {'pop': false});
        return;
      } else {}
    } on TimeoutException catch (e) {
      _timer.cancel();
      print('Timeout Error: $e');
    } on Socket catch (e) {
      _timer.cancel();
      print('Socket Error: $e');
    } on Error catch (e) {
      _timer.cancel();
      print('General Error: $e');
    }
  }

  //this called auto on page loader when user clicks button
  Future getUserInfo() async {
    //check if user is verified or send email verification link
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    print(email);
    try {
      var url =
          'https://authentication.topshottimer.co.za/authentication/createAccountVerifyEmailMailer.php';
      var res = await post(Uri.parse(url), headers: {
        "Accept": "application/jason"
      }, body: {
        //TODO uncomment when testing is complete
        "emailAddress": email,
      });
      //An error will occur when using an email that dose not exist (formatexception)
      //MAYBE WE NEED THI??
      try {
        Map<String, dynamic> data = json.decode(res.body);
        String status = data["success"];
        print(status);
        //TODO show that message was sent successfully
        if (status == 'true') {
          print("EMAIL SENT SUCCESSFUL");
        } else if (status == 'false') {
          print("EMAIL WAS NOT SENT DUE TO ERROR");
        }
      } on FormatException catch(e) {
        print(e);
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  //dialog that is shown when resend email button is clicked
  emailSent() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
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
                    Text(
                      "Verification Email Sent!",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text(
                                  "Confirm",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      fontFamily: 'Montserrat-Regular',
                                      letterSpacing: 0.2,
                                      color: Colors.white),
                                ),
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
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    showDialog(context: context, builder: (context) => dialog);
  }
}
