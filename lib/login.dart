import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:topshottimer/signup.dart' as signup;
import 'package:topshottimer/resetPassword.dart' as resetPassword;
import 'package:http/http.dart' as http;
import 'package:topshottimer/verifyEmail.dart' as verify;

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
  final password = TextEditingController();

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
        email.text = value;
      },
    );
  }

  //password widget
  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: password,
      // maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        return null;
      },
      onSaved: (String value) {
        password.text = value;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                  borderRadius: BorderRadius.circular(35.0),
              child: Image.asset("assets/icon.png",)
              ),
              SizedBox(height: 30),
              _buildEmail(),
              _buildPassword(),
              SizedBox(height: 30),
              Row(
                children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
              child: Divider(
              color: Colors.black,
                thickness: 2,
              )
              ),
              ),
                  RichText(
                      text: TextSpan(
                          text: "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) =>
                                      resetPassword.resetPassword(email.text)));
                            }
                      )
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 2,
                  )
                    )
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 250,
               height: 40,
               child: RaisedButton(
                  child: Text('Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState.validate()) {
                      return;
                    }
                    _formKey.currentState.save();
                    print("fuck fuck");
                    print(email.text);
                    print(password.text);
                    print("Hello World");
                    //saveData(context);
                    //Send to API
                    updateData(email.text, password.text);
                  },
                 color: Colors.red,
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                width: 250,
                height: 40,
                child: RaisedButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        print("email hererererererere");
                        print(email.text);
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) => signup.FormScreen(email.text)));
                      },
                    color: Colors.red,
                  )
              ),
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
    //display message because they are not a user
    if (status == "notuser") {
      //saveUserInformation("1", "donovan@simplx.co.za", "e1a7b8ad45f95c9d0f401381236891d369ca80790393e307805e1dd700f8ecca", "true");
      print("we don't have this user");
      //Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
      //createError();
    }
    //is a user but they haven't verified their email address
    else if (status == "nonverified" && id != null) {
      print("we have this user but they are not verified");
      saveUserInformation(id, email, hashedPassword, "false");
      Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
    }
    //is a user and is verified email so they can use the app
    else if (status == "verified" && id != null) {
      print("user details is all in order");
      saveUserInformation(id, email, hashedPassword, "true");
      Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    } else{

  }
}
//takes the users information and stores it in shared preferences
saveUserInformation(var id, String email, String hashedPassword, String status) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('email', email);
    await prefs.setString('password', hashedPassword);
    await prefs.setString('verfiy', status);
  }
  Future createError(){

    AlertDialog alert = AlertDialog(
      title: Text("Inccorrect details!"),
      actions:[
        FlatButton(child: Text("okay"),
          onPressed: () {
            Navigator.pop(context);
          },),
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