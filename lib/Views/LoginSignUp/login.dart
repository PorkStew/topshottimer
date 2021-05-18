import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/LoginSignUp/signup.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPassword.dart';
import 'package:topshottimer/Views/PageSelector.dart';
import 'package:topshottimer/loading.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:topshottimer/global.dart';

//TODO remove prints when beta and release
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  //variable declarations
  int _count = 0;
  //amount should be 6 this will then show the createAccountDialog
  int _whenToDisplay = 6;
  bool _passwordVisible = false;
  bool _loading = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _controller = Get.put(Controller());
  FocusNode _focusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //email widget
  Widget _buildEmail(BuildContext context) {
    final _node = FocusScope.of(context);
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.email, color: Theme.of(context).iconTheme.color),
          labelText: 'Email',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'Montserrat-Regular',
              letterSpacing: 0.2,
              color: Colors.grey)),
      onEditingComplete: () => _node.nextFocus(),
      textInputAction: TextInputAction.next,
      controller: _email,
      //called when _formKey.validate is called
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
  Widget _buildPassword(BuildContext context) {
    final node = FocusScope.of(context);
    return TextFormField(
      decoration: InputDecoration(
          prefixIcon:
              Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
          labelText: 'Password',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'Montserrat-Regular',
              letterSpacing: 0.2,
              color: Colors.grey),
          //show and hide password
          suffixIcon: IconButton(
            color: Theme.of(context).iconTheme.color,
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
              Timer.run(() => _focusNode.unfocus());
            },
          )),
      onFieldSubmitted: (_) => node.unfocus(),
      textInputAction: TextInputAction.done,
      focusNode: _focusNode,
      obscureText: !_passwordVisible,
      controller: _password,
      //called when _formKey.validate is called
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

  //main view with all widgets combined
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : KeyboardDismisser(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Form(
                key: _formKey,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipRRect(
                          child: Image.asset(
                        "assets/target-green@3x.png",
                        width: 130,
                        height: 130,
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
                                      Text(
                                        "Login",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 24,
                                            fontFamily: 'Montserrat-Regular',
                                            letterSpacing: 0.2),
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 5),
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Please sign in to continue",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 17,
                                            fontFamily: 'Montserrat-Regular',
                                            letterSpacing: 0.2,
                                            color: Colors.grey),
                                      ),
                                    ],
                                  )),
                              SizedBox(height: 5),
                              _buildEmail(context),
                              SizedBox(height: 15),
                              _buildPassword(context),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: RichText(
                            text: TextSpan(
                                text: "Forgot your password?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15,
                                    fontFamily: 'Montserrat-Regular',
                                    letterSpacing: 0.2,
                                    color: Themes.darkButton2Color),
                                recognizer: new TapGestureRecognizer()
                                  ..onTap = () {
                                    //TODO change this i think
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResetPassword(_email.text)));
                                  })),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                          width: 268,
                          height: 60,
                          child: Obx(() => ElevatedButton(
                                onPressed: _controller.btnState.value
                                    ? () => loginProcess()
                                    : null,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      fontFamily: 'Montserrat-Regular',
                                      letterSpacing: 0.2,
                                      color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Themes.darkButton1Color,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ))),
                      SizedBox(
                        height: 26,
                      ),
                      SizedBox(
                          width: 268,
                          height: 60,
                          child: ElevatedButton(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                fontFamily: 'Montserrat-Regular',
                                letterSpacing: 0.2,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SignUp(_email.text)));
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Themes.darkButton2Color,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  //login button
  loginProcess() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    nullPreferences();
    checkUserInformation(_email.text, _password.text);
  }

  //set user preferences to null before login process takes places
  nullPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  //once user clicks login button the details given are check with the database, json is returned stating if they are a user or not
  checkUserInformation(String _email, String _password) async {
    //change state to show loading screen
    setState(() => _loading = true);
    //convert user password to sha256
    String _hashedPassword = "";
    var _bytes = utf8.encode(_password);
    var _digest = sha256.convert(_bytes);
    _hashedPassword = _digest.toString();

    var url = 'https://www.topshottimer.co.za/login.php';
    try {
      var res = await post(Uri.parse(url), headers: {
        "Accept": "application/jason"
      }, body: {
        //get this information from user defaults
        "emailAddress": _email,
        "password": _hashedPassword,
      }).timeout(Duration(seconds: 5));
      //convert json and store in string's
      Map<String, dynamic> data = json.decode(res.body);
      String _id = data['id'];
      String _status = data["status"];
      String _firstName = data["firstName"];
      String _lastName = data["lastName"];
      //display message because they are not a user
      if (_status == "not-user") {
        setState(() => _loading = false);
        _count++;
        if (_count < _whenToDisplay) {
          setState(() => _loading = false);
          incorrectDetailsDialog();
          return;
        } else {
          setState(() => _loading = false);
          createAccountDialog();
          _count = 0;
          return;
        }
      }
      //is a user but they haven't verified their email address
      else if (_status == "non-verified" && _id != null) {
        saveUserInformation(_id, _email, _hashedPassword, "non-verified",
            _firstName, _lastName);
        Navigator.pushReplacementNamed(context, '/LoginSignUp/verifyEmail',
            arguments: {'email': _email});
      }
      //is a user and is verified email so they can use the app
      else if (_status == "verified" && _id != null) {
        final _controller = Get.put(Controller());
        _controller.revenueCatSetListener(_id);
        saveUserInformation(
            _id, _email, _hashedPassword, "verified", _firstName, _lastName);
        print("where do i go from here");
        //Navigator.pushReplacementNamed(context, '/PageSelector');
        _controller.revenueCatSetListener(_id);
        Get.off(pageSelector());
        //if details are not correct then remove loading and stay at loading screen
      } else {
        setState(() => _loading = false);
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
    } on SocketException catch (e) {
      print('Socket Error: $e');
    } on Error catch (e) {
      print('General Error: $e');
    }
  }

  //takes the users information and stores it in shared preferences
  saveUserInformation(var _id, String _email, String _hashedPassword, String _status, String _firstName, String _lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stopCounter', 0);
    await prefs.setString('id', _id);
    await prefs.setString('email', _email);
    await prefs.setString('password', _hashedPassword);
    await prefs.setString('verify', _status);
    await prefs.setString('firstName', _firstName);
    await prefs.setString('lastName', _lastName);
    await prefs.setBool('loginBefore', true);
  }

  //called when user details are incorrect
  incorrectDetailsDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 140,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Incorrect Details!",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)),
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Try Again",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Themes.darkButton2Color,
                    radius: 40,
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    //shows dialog since it's inside a method
    showDialog(context: context, builder: (context) => dialog);
  }

  //shown after a certain number of attempts specified at the top of this code at variable declarations
  createAccountDialog() {
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 160,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Having Trouble?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Don't feel left out, Sign up now!",
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          fontFamily: 'Montserrat-Regular',
                          letterSpacing: 0.2,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10)),
                                color: Themes.darkButton1Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Try Again",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // Navigator.pop(context);
                              //Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => SignUp(_email.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10)),
                                  //color: Themes.PrimaryColorRed,
                                  color: Themes.darkButton2Color),
                              height: 45,
                              child: Center(
                                child: Text("Sign Up",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2,
                                        color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Themes.darkButton2Color,
                    radius: 40,
                    child: Image.asset(
                      "assets/Exclamation@3x.png",
                      height: 53,
                    ))),
          ],
        ));
    //shows dialog since it's inside a method
    showDialog(context: context, builder: (context) => dialog);
  }
}
