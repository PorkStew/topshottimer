import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:topshottimer/Views/LoginSignUp/login.dart';

class ResetPasswordConfirm extends StatefulWidget {
  _ResetPasswordConfirmState createState() => _ResetPasswordConfirmState();
}

class _ResetPasswordConfirmState extends State<ResetPasswordConfirm> {
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
                Text("Email successfully sent", textAlign: TextAlign.center, style:  TextStyle(
                    fontSize: 40
                ),),
                Container(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text("An email has been sent to:", textAlign: TextAlign.center, style:  TextStyle(
                        fontSize: 17,
                      ),),
                      //Text(emailAddress, style:  TextStyle(
                       // fontSize: 17,
                      //),),
                      Text(arguments['email'], style:  TextStyle(
                        fontSize: 17,
                      ),),
                      SizedBox(
                        height: 30,
                      ),
                      Text("Please follow the instructions in the email to reset your password for your Top Shot Timer account.", textAlign: TextAlign.center, style:  TextStyle(
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
                                  print("resend email here");
                                  Navigator.pop(context);
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
                          print("HELO CONFIRM FOR ME PEASE");
                          //checkUserVerified();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'RETURN TO LOGIN',
                           style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        color: Colors.red,
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
