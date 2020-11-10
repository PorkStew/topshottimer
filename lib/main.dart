import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:topshottimer/resetPassword.dart';
import 'package:topshottimer/signup.dart' as signup;
import 'package:topshottimer/resetPassword.dart' as resetPassword;
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/views/timer.dart' as TimerPage;


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
        primarySwatch: Colors.blue,
      ),
      home: Login() ,
    );
  }
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends  State<Login> {
  String _email;
  String _password;
  final email = TextEditingController();
  final passwords = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //email widget
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      controller: email,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  //password widget
  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      // maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      backgroundColor: Colors.blueGrey,
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildEmail(),
              _buildPassword(),
              SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: "Forgot Password?",
                  style: TextStyle(color: Colors.black),
                  recognizer: new TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => resetPassword.resetPassword()));
                    }
                )
              ),
              SizedBox(height: 30),
              RaisedButton(
                child: Text('Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),

                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  print(_email);
                  print(_password);
                  print("Hello World");
                  saveData(context);
                  //Send to API
                  updateData(_email, _password);
                },
              ),
              RaisedButton(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => signup.FormScreen(email.text)));
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Future updateData(String email, String password) async {
    String hashedPassword = "";
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    hashedPassword = digest.toString();
    var url = 'https://www.topshottimer.co.za/login.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          "emailAddress": email,
          "password": hashedPassword,
        }
    );
    print("before res.body");
    var data = json.decode(res.body);

    print(data);
    if (data != false) {
      print("Success the details provided are correct");
      // go to home screen
     // Navigator.push(context, MaterialPageRoute(builder: (context) => TimerPage.TimerPage()));
    } else {
      //print a message if details are incorrect
      print("incorrect details! Please Try Again");
    }
  }
  Future<void> saveData(context) async {
    print("token");
    var session = FlutterSession();
    await session.set('id', '111111');
    dynamic token = await FlutterSession().get("id");
    print("printing token for you");
    print(token);
    print("calling text");

    //Navigator.push(context, MaterialPageRoute(builder: (context) => signup.FormScreen("something good")));
  }


}