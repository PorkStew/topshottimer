import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:topshottimer/Views/LoginSignUp/login.dart' as login;
import 'package:http/http.dart' as http;

class verifyEmail extends StatefulWidget {
  @override
  _verifyEmailState createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  //variable declaration
  int _count = 0;
  @override
  void initState(){
    super.initState();
    //check if user is verified or send email verification link
    getUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
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
                            "assets/mail-1454734_1920.png",
                            width: 140,
                          )),
                    ),
                    Text("Email Verification Required", textAlign: TextAlign.center, style:  TextStyle(
                        fontSize: 40
                    ),),
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text("An email has been sent to:", textAlign: TextAlign.center, style:  TextStyle(
                              fontSize: 17,
                          ),),
                          Text(arguments['email'], style:  TextStyle(
                              fontSize: 17,
                          ),),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Please follow the instructions in the verification email to finish creating your Top Shot Timer account. Once it's done you will be able to login and start shooting", textAlign: TextAlign.center, style:  TextStyle(
                              fontSize: 17,
                          ),),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Didn't receive an email?",
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                        getUserInfo();
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
                        width: 250,
                        height: 40,
                       child: RaisedButton(
                          onPressed: (){
                            //checkUserVerified();
                            //TODO we need to clear the user details because it will take them to verificcation if they close the app
                            Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
                          },
                          child: Text(
                              'LOGIN',
                            style: TextStyle(fontSize: 15),

                          ),
                          color: Themes.PrimaryColorRed,
                          shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
  //this called auto on page oad or when user clicks button
  //TODO REMOVE mailerVerifyEmail.php from server
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
      // Map<String, dynamic> data = json.decode(res.body);
      // String status = data["status"];
      // if(status == "non-verified" && _count != 0) {
      //   emailSent();
      // }
      _count++;
    }catch (error) {
      print(error.toString());
    }
  }
  //TODO REMOVE BELOW METHOD and checkUserIsVerified.php from server
  // checkUserVerified() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = await prefs.getString('email');
  //   String password = await prefs.getString('password');
  //   String verified = await prefs.getString('verify');
  //   if(verified == 'true'){
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
  //   }
  //   var url = 'https://www.topshottimer.co.za/checkUserIsVerified.php';
  //   var res = await http.post(
  //       Uri.encodeFull(url), headers: {"Accept": "application/jason"},
  //       body: {
  //         //get this information from user defaults
  //         "emailAddress": email,
  //         "password": password,
  //       }
  //   );
  //   Map<String, dynamic> data = json.decode(res.body);
  //   //String id = data['id'];
  //   String status = data["verified"];
  //   //display message because they are not a user
  //   if (status == "error") {
  //     //TODO should we not just return to login if there is no user
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => login.Login()));
  //   }
  //   //is a user but they haven't verified their email address
  //   else if (status == "non-verified") {
  //     await prefs.setString('verify', "non-verified");
  //     notVerifiedError();
  //   }
  //   //is a user and is veried email so they can use the app
  //   else if (status == "verified") {
  //     await prefs.setString('verify', "verified");
  //     //saveUserInformation(id, email, hashedPassword);
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
  //   } else{
  //
  //   }
  // }

  // getEmail() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String email = await prefs.getString('email');
  //   _emailAddress = email;
  // }
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
                        color: Colors.red,
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


