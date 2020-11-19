import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/verifyEmail.dart' as verify;
import 'package:topshottimer/login.dart' as Login;
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  //accepts email from the login if they have entered one
  String something = "First Name";
  FormScreen(this.something);

  @override
  State<StatefulWidget> createState() {
    //need to accept a aurgement
    return FormScreenState(this.something);
  }
}

class FormScreenState extends  State<FormScreen> {
  //variable declarations
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _conPassword;
  String emailFromLogin;
  //text editing controllers
  final passwords = TextEditingController();
  final conPasswords = TextEditingController();
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //allows the accepting of data from another view
  FormScreenState(this.emailFromLogin);
  //following 5 widgets are inputs for user information with validation
  //first name input and validation
  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'First Name'),
      validator: (String value) {
        if (value.isEmpty) {
          //saveData(context);
          return 'First name is Required';
        }
        return null;
      },
      onSaved: (String value) {
        _firstName = value;
      },
    );
  }
  //last name input and validation
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
  //email input and validation
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
  //password input and validation
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

  ////confirm passwor input and validation
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
              SizedBox(height: 30),
              SizedBox(
                  width: 250,
                  height: 40,
                 child: RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 20),
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
                   color: Colors.red,
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
  //sends user input to php file where it's inserted into the db
  Future sendData(String firstName, String lastName, String email, String password) async {
    //hashes user password
    String hashedPassword = "";
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    hashedPassword = digest.toString();
    print(hashedPassword);
    //this decodes the hashed password
    //var de = utf8.decode(bytes);
    //print(de);
    //inserts the user data and recives a true or false based on if the user already is in db or not
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
     // saveUserInformation(id, email, hashedPassword);
      //decodes incoming php data
      Map<String, dynamic> data = json.decode(res.body);
      String id = data['id'];
      String status = data["status"];
      print(id);
      print(status);
      if(id != "" || status == "notuser")
      {
         print("is not a user and isnt verified");
         saveUserInformation(id, email, hashedPassword, "false");
         Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));

      } else if(id != "" || status == "user"){
        print("this is a user and is verified");
        saveUserInformation(id, email, hashedPassword, "true");
        //should print like an error saying user already exists with that email.
        AlertDialog alert = AlertDialog(
          title: Text("Account already exits with this email address!"),
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
      //var data = json.decode(res.body);
      //print(data);
      // if(data == false){
      //   print("not a user so account will be created");
      //   print("once sent to the verify email page then go to login and get the id there");
      // } else if(data == true){
      //   print("Already a User");
      // }
      //print("account created");
    }catch (error) {
      print(error.toString());
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
}