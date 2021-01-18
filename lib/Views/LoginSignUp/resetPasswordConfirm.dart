import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:topshottimer/Views/LoginSignUp/login.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPassword.dart';
import 'package:topshottimer/loading.dart';

class ResetPasswordConfirm extends StatefulWidget {
  _ResetPasswordConfirmState createState() => _ResetPasswordConfirmState();
}

class _ResetPasswordConfirmState extends State<ResetPasswordConfirm> {
  bool loading = false;
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
                              style: TextStyle(color: Colors.blue, fontSize: 15),
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
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Login',
                           style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        color: Colors.red,
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
                          //checkUserVerified();
                          //Navigator.push(context,
                              //MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Resend Email',
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        color: Colors.red,
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
                        Navigator.pop(context,true)
                      },
                      style: TextStyle(
                          color: Colors.deepPurple,
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

  resetPassword(String email) async{
    try{
      print(email);
      var url = 'https://www.topshottimer.co.za/mailer2.php';
      var res = await post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "emailAddress": email,
          }
      );
    }catch (error) {
      print(error.toString());
    }
  }

}
