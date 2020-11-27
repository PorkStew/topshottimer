import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:http/http.dart' as http;

class verifyEmail extends StatefulWidget {

  @override
  _verifyEmailState createState() => _verifyEmailState();
}

class _verifyEmailState extends State<verifyEmail> {
  @override
  void initState(){
    super.initState();
   getUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 15, left: 0, right: 0),
                child: Column(
                  children: [
                    Text("Verify Email!", style:  TextStyle(
                        fontSize: 40
                    ),),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Text("An email has been sent to ", style:  TextStyle(
                              fontSize: 15
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
                                  text: "Resend email?",
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                        print("resend email here");
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
                            print("df");
                            checkUserVerified();
                          },
                          child: Text(
                              'Confirm',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          color: Colors.red,
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
  getUserInfo() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    print("email here");
    print(email);
    try{
      var url = 'https://www.topshottimer.co.za/mailer.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "emailAddress": email,
          }
      );
      Map<String, dynamic> data = json.decode(res.body);
      // saveUserInformation(id, email, hashedPassword);
      //decodes incoming php data
      // Map<String, dynamic> data = json.decode(res.body);
      // String id = data['id'];
      // String status = data["status"];
      // print(id);
      // print(status);

    }catch (error) {
      print(error.toString());
    }
  }
  checkUserVerified() async{
    //String hashedPassword = "";
   // var bytes = utf8.encode(password);
   // var digest = sha256.convert(bytes);
   // hashedPassword = digest.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    String password = await prefs.getString('password');
    String verified = await prefs.getString('verify');
    if(verified == 'true'){
    //TODO: go to home page
      Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    }
    var url = 'https://www.topshottimer.co.za/checkUserIsVerified.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "emailAddress": email,
          "password": password,
        }
    );
    print("before res.body");
    Map<String, dynamic> data = json.decode(res.body);
    //String id = data['id'];
    String status = data["verified"];
    //print("ss");
    //print(id);
    print(status);
    //print("dddd");
    //display message because they are not a user
    if (status == "error") {
      print("we don't have this user");
      createError();
    }
    //is a user but they haven't verified their email address
    else if (status == "false") {
      await prefs.setString('verify', "false");
      print("we have this user but they are not verified");
      print("email not verified");
      //TODO: add a error message to tell user that their email is still not verified
      //saveUserInformation(id, email, hashedPassword);
     // Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
    }
    //is a user and is veried email so they can use the app
    else if (status == "true") {
      print("user details is all in order");
      await prefs.setString('verify', "true");
      //saveUserInformation(id, email, hashedPassword);
      Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    } else{

    }
  }
  Future createError(){
    AlertDialog alert = AlertDialog(
      title: Text("Inccorrect details!"),
      actions:[
        FlatButton(child: Text("okay"),
          onPressed: () {
            Navigator.pop(context);
          },),
        RichText(
            text: TextSpan(
                text: "No Email?",
                style: TextStyle(color: Colors.black),
                recognizer: new TapGestureRecognizer()
                  ..onTap = () {
                    //Navigator.push(context, MaterialPageRoute(
                      //  builder: (context) =>
                        //    resetPassword.resetPassword(email.text)));
                  }
            )
        ),
      ],
    );
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return alert;
        }
    );
    //saveUserInformation(id, email, hashedPassword);
    //go to login screen
    // Navigator.push(context, MaterialPageRoute(builder: (context) => ));
  }
}

