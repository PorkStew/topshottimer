import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      body: Container(
      child: Center(
        child: RaisedButton(
          onPressed: (){
            getUserInfo();
          },
          child: Text('Enabled Button', style: TextStyle(fontSize: 20)),
          ),
        )
      )
    );
  }
  getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    try{
      var url = 'https://www.topshottimer.co.za/mailer.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "emailAddress": email,
          }
      );
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

