import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:topshottimer/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

//TODO better handling of errors when they click the wrong link
//TODO if they are verified then the system must send a different file to display that they are already verified.
class SignUp extends StatefulWidget {
  //accepts email from the login if they have entered one
  String something = "";
  SignUp(this.something);

  @override
  State<StatefulWidget> createState() {
    //accepts value from previous view
    return SignUpState(this.something);
  }
}

class SignUpState extends  State<SignUp> {
  //variable declarations
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _conPassword;
  String _emailFromLogin;
  bool _passwordVisible = false;
  bool _loading = false;
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //allows the accepting of data from another view
  SignUpState(this._emailFromLogin);
  //following 5 widgets are inputs for user information with validation
  //first name input and validation
  Widget _buildFirstName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'FIRST NAME',
        prefixIcon: Icon(Icons.perm_identity, color: Theme.of(context).iconTheme.color),
      ),
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
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.perm_identity, color: Theme.of(context).iconTheme.color),
          labelText: 'LAST NAME',
      ),
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
      decoration: InputDecoration(
        labelText: 'EMAIL',
          prefixIcon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),

      ),
      initialValue: _emailFromLogin,
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
      decoration: InputDecoration(
          labelText: 'PASSWORD',
        prefixIcon: Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
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
      ),
      ),
      obscureText: !_passwordVisible,
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
  ////confirm password input and validation
  Widget _buildConPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'CONFIRM PASSWORD',
        prefixIcon: Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
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
        ),
      ),
      obscureText: !_passwordVisible,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password cant be empty';
        }
        //checks if passwords are matching
        if(value != _password){
          print("passwords don't match");
          return "passwords don't match";
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
    //dsiplays loading screen when set state is true
    return _loading ? Loading() : Scaffold(
      appBar: AppBar(title: Text("SIGN UP"), iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),),
      //allows for the movement of widget to not be blocked by the keyboard
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                _buildFirstName(),
                SizedBox(height: 15),
                _buildLastName(),
                SizedBox(height: 15),
                _buildEmail(),
                SizedBox(height: 15),
                _buildPassword(),
                SizedBox(height: 15),
                _buildConPassword(),
                SizedBox(height: 30),
                SizedBox(
                    width: 250,
                    height: 40,
                    child: RaisedButton(
                      child: Text(
                        'SUBMIT',
                        style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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
                        setState(() => _loading = true);
                        sendData(_firstName, _lastName, _email, _password);
                      },
                      color: Themes.PrimaryColorRed,
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //sends user input to php file where it's inserted into the db
  sendData(String firstName, String lastName, String email, String password) async {
    //hashes user password
    String hashedPassword = "";
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    hashedPassword = digest.toString();
    //inserts the user data and receives a true or false based on if the user already is in db or not
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
      Map<String, dynamic> data = json.decode(res.body);
      String id = data['id'];
      String status = data["status"];
      if(id == "" || status == "not-user")
      {
        print("this is not a user");
         saveUserInformation(id, email, hashedPassword, "false");
         Navigator.pushNamedAndRemoveUntil(context, '/LoginSignUp/verifyEmail', (r) => false ,arguments: {'email': email});
      } else if(id != "" && status == "user"){
        print("this is a user");
        setState(() => _loading = false);
        saveUserInformation(id, email, hashedPassword, "true");
        //show dialog
        accountInUseDialog();
      }
    }catch (error) {
      setState(() => _loading = false);
      print(error.toString());
    }
  }

  //takes the users information and stores it in shared preferences
  saveUserInformation(var id, String email, String hashedPassword, String status) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('email', email);
    await prefs.setString('password', hashedPassword);
    await prefs.setString('verify', status);
  }
  //account email is already used
  accountInUseDialog(){
    SimpleDialog carDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Account already in use!", style: TextStyle(fontSize: 20),),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      print("CONFIRM");
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
                        child: Text("OKAY",
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
