import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/PageSelector.dart';
import 'package:topshottimer/signup.dart' as signup;
import 'package:topshottimer/resetPassword.dart' as resetPassword;
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/views/timer.dart' as TimerPage;
import 'package:topshottimer/verifyEmail.dart' as verify;

//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   //root widget
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Top Shot Timer',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Login() ,
//     );
//   }
// }

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
                              builder: (context) =>
                                  resetPassword.resetPassword()));
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
                  //saveData(context);
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

  updateData(String email, String password) async {
    String hashedPassword = "";
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    hashedPassword = digest.toString();

    var url = 'https://www.topshottimer.co.za/login.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "emailAddress": email,
          "password": hashedPassword,
        }
    );
    print("before res.body");
    Map<String, dynamic> data = json.decode(res.body);
    String id = data['id'];
    String status = data["status"];
    print("ss");
    print(id);
    print(status);
    print("dddd");
    if (status == "notuser") {
      print("we don't have this user");
      //Navigator.push(
      //    context, MaterialPageRoute(builder: (context) => login.Login()));
    }
    else if (status == "nonverified" && id != null) {
      print("we have this user but they are not verified");
      saveUserInformation(id, email, hashedPassword);
      Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
    } else if (status == "verified" && id != null) {
      print("user details is all in order");
      saveUserInformation(id, email, hashedPassword);
      Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector()));
    } else{
 // Navigator.push(
 // context, MaterialPageRoute(builder: (context) => login.Login()));
  }
}

saveUserInformation(var id, String email, String hashedPassword) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('email', email);
    await prefs.setString('password', hashedPassword);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => signup.FormScreen("something good")));
  }

}