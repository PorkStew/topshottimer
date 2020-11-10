import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
class FormScreen extends StatefulWidget {
  //allows the accepting of data from another view
  String something;
  FormScreen(this.something);

  @override
  State<StatefulWidget> createState() {
    //need to accept a aurgement
    return FormScreenState(this.something);
  }
}

class FormScreenState extends  State<FormScreen> {
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _conPassword;
  final passwords = TextEditingController();
  final conPasswords = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //allows the accepting of data from another view
  String emailFromLogin;
  FormScreenState(this.emailFromLogin);

  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First name here'),
      validator: (String value) {
        if (value.isEmpty) {
          saveData(context);
          return 'First name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _firstName = value;
      },
    );
  }
  Widget _buildLastName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Last Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last name is Required';
        }

        return null;
      },
      onSaved: (String value) {
        _lastName = value;
      },
    );
  }
  //email text area
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      initialValue: emailFromLogin,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }
        //regex
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }
  //password text area
  Widget _buildPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      controller: this.passwords,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Last name is Required';
        }
        //regex to check strength of password
        if (!RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
            .hasMatch(value)) {
          return 'Please enter a valid password';
        }
        return null;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }
  //confirm password text area
  Widget _buildConPassword() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password cant be empty';
        }
        //checks if passwords are matching
        if(value != passwords.text){
          print("passwords dont match");
          print(value);
          print(passwords.text);
        }

        if (!RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
            .hasMatch(value)) {
          return 'Password not strong';
        }

        return null;
      },
      onSaved: (String value) {
        _conPassword = value;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Container(
        margin: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildFirstName(),
              _buildLastName(),
              _buildEmail(),
              _buildPassword(),
              _buildConPassword(),
              SizedBox(height: 100),
              RaisedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    return;
                  }
                  _formKey.currentState.save();
                  print(_firstName);
                  print(_lastName);
                  print(_email);
                  print(_password);
                  print(_conPassword);
                  //Send to API
                  //send user information to the database
                  sendData(_firstName, _lastName, _email, _password);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
  Future sendData(String firstName, String lastName, String email, String password) async {
    String hashedPassword = "";
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    hashedPassword = digest.toString();
    print("Digest as hex string: $digest");
    var de = utf8.decode(bytes);
    print(de);
    try{
      var url = 'https://www.topshottimer.co.za/create.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "firstName": firstName,
            "lastName": lastName,
            "emailAddress": email,
            "password": hashedPassword,
          }
      );
      var data = json.decode(res.body);

      print(data);
      if(data == false){
        print("not a user so account will be created");
      } else if(data == true){
        print("Already a User");
      }
      //print("account created");
    }catch (error) {
      print(error.toString());
    }
  }
  Future<void> saveData(context) async {
    dynamic token = await FlutterSession().get("id");
    print(token);

  }
}