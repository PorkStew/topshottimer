import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:topshottimer/Views/LoginSignUp/signup.dart' as signUp;
import 'package:topshottimer/Views/LoginSignUp/resetPassword.dart' as resetPassword;
import 'package:topshottimer/Views/LoginSignUp/verifyEmail.dart' as verify;
//TODO we don't need controllers any mroe
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  //variable declarations
  int _count = 0;
  int _displayNoAccount = 0;
  int _whenToDisplay = 6;
  bool _passwordVisible = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //email widget
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),
        //labelText: 'Email',
          labelText: 'EMAIL'
      ),
      controller: _email,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _email.text = value;
      },

    );
  }

  //password widget
  Widget _buildPassword() {
    return TextFormField(

      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
          labelText: 'PASSWORD',

      //contentPadding: EdgeInsets.zero,
      //prefix: Icon(Icons.lock),
      suffixIcon: IconButton(color: Theme.of(context).iconTheme.color,
        icon: Icon(
          // Based on passwordVisible state choose the icon
          _passwordVisible
              ? Icons.visibility
              : Icons.visibility_off,
        ),
        onPressed: () {
          // Update the state i.e. toogle the state of passwordVisible variable
          setState(() {
            _passwordVisible = !_passwordVisible;
          });
        },
      )),
      obscureText: !_passwordVisible,
      controller: _password,
      // maxLength: 10,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _password.text = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),

        //margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
           // decoration: BoxDecoration(
            //  image: DecorationImage(
                //image: AssetImage("assets/hizir-kaya-ExxuYNsViC4-unsplash.jpg"),
             //   fit: BoxFit.cover,
           //   ),
           // ),
            //margin: EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 ClipRRect(
                     borderRadius: BorderRadius.circular(35.0),
                     child: Image.asset(
                       "assets/target-red.png",
                     )),
                SizedBox(height: 30),
                Container(

                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: Container(
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            children: [
                              Text("Login", style: TextStyle(
                                fontSize: 24,
                              ),),
                            ],
                          )
                        ),
                        SizedBox(height: 5),
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Text("Please sign in to continue", style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey
                                ),),
                              ],
                            )
                        ),
                        SizedBox(height: 5),
                        _buildEmail(),
                        SizedBox(height: 15),
                        _buildPassword(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 40.0, right: 10.0),
                          child: Divider(
                            thickness: 2,
                          )),
                    ),
                    RichText(
                        text: TextSpan(
                            text: "Forgot Password?",
                            style: TextStyle(color: Colors.blueAccent),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => resetPassword
                                            .resetPassword(_email.text)));
                              })),
                    Expanded(
                        child: Container(
                            margin:
                            const EdgeInsets.only(left: 10.0, right: 40.0),
                            child: Divider(
                              thickness: 2,
                            ))),
                  ],
                ),
                SizedBox(height: 30),
                SizedBox(
                    width: 250,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState.validate()) {
                          return;
                        }
                        updateData(_email.text, _password.text);
                      },
                      color: Themes.PrimaryColorRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      //side: BorderSide(color: Colors.red))),
                    )),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: 250,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    signUp.FormScreen(_email.text)));
                      },
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
              ],
            ),
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
    var res = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "application/jason"
    }, body: {
      //get this information from user defaults
      "emailAddress": email,
      "password": hashedPassword,
    });
    Map<String, dynamic> data = json.decode(res.body);
    String id = data['id'];
    String status = data["status"];
    //display message because they are not a user
    if (status == "not-user") {
      _count++;
      if(_count < _whenToDisplay){
        incorrectDetailsDialog();
        return;
      } else {
        createAccountDialog();
        _count = 0;
        return;
      }
    }
    //is a user but they haven't verified their email address
    else if (status == "non-verified" && id != null) {
      saveUserInformation(id, email, hashedPassword, "non-verified");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => verify.verifyEmail(email)));
    }
    //is a user and is verified email so they can use the app
    else if (status == "verified" && id != null) {
      saveUserInformation(id, email, hashedPassword, "verified");
      //Navigator.of(context).pushReplacementNamed('/PageSelector');
      print("where do i go from here");
      Navigator.pushReplacementNamed(context, '/PageSelector');
      //Navigator.push(context,
          //MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    } else {

    }
  }

//takes the users information and stores it in shared preferences
  saveUserInformation(var id, String email, String hashedPassword, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('email', email);
    await prefs.setString('password', hashedPassword);
    await prefs.setString('verify', status);
  }

  incorrectDetailsDialog(){
      SimpleDialog carDialog = SimpleDialog(
        contentPadding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Text("Incorrect Details!", style: TextStyle(fontSize: 20),),
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
                          color: Themes.PrimaryColorRed,
                        ),
                        height: 45,
                        child: Center(
                          child: Text("TRY AGAIN",
                              style: TextStyle(fontSize: 20)),
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


  createAccountDialog() {
    SimpleDialog carDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Having Trouble?", style: TextStyle(fontSize: 25),),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Don't feel left out, Sign up now!", textAlign: TextAlign.center, style: TextStyle(fontSize: 20),),
            ),
            SizedBox(
              height: 30,
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
                        BorderRadius.only(bottomLeft: Radius.circular(6)),
                        color: Colors.blueAccent,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("TRY AGAIN",
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => signUp.FormScreen(_email.text)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(6)),
                        color: Themes.PrimaryColorRed,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("SIGN UP",
                            style: TextStyle(fontSize: 20)),
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
