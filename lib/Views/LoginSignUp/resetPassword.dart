import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/loading.dart';
import 'package:topshottimer/global.dart';

class ResetPassword extends StatefulWidget {
  //accepts email from the login if they have entered one
  String email = "";
  ResetPassword(this.email);

  @override
  State<StatefulWidget> createState() {
    return _ResetPasswordState(this.email);
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  //variable declarations
  String _email;
  String _emailFromLogin;
  bool loading = false;
  //accepts email from login if one is entered
  _ResetPasswordState(this._emailFromLogin);
  final controller = Get.put(Controller());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //email input and validation
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'Montserrat-Regular',
              letterSpacing: 0.2, color: Colors.grey),
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).iconTheme.color,
        ),
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
        if (RegExp(r"\s+").hasMatch(value)) {
          return 'White Spaces not Allowed';
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
        print(_email);
      },
    );
  }
  //main view with all widgets combined
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : KeyboardDismisser(
            child: Scaffold(
                //resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  title: Text("Sign Up", style: TextStyle(color: Colors.white)),
                  iconTheme:
                      IconThemeData(color: Theme.of(context).iconTheme.color),
                ),
                //allows for the movement of widget to not be blocked by the keyboard
                body: LayoutBuilder(
                  builder: (context, constraint) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraint.maxHeight),
                        child: IntrinsicHeight(
                            child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(30),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          height: 129,
                                            child: Image.asset(
                                              "assets/padlock@3x.png",
                                              width: 129,
                                            )
                                            ),
                                      ),
                                      SizedBox(height: 30),
                                      Text("Forgot Password?", style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 25,
                                          fontFamily: 'Montserrat-Regular',
                                          letterSpacing: 0.2,
                                      ),),
                                      SizedBox(height: 20),
                                      Text("Confirm your email and we'll send the instructions.", textAlign: TextAlign.center, style:  TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17,
                                          fontFamily: 'Montserrat-Regular',
                                          letterSpacing: 0.2,
                                          color: Colors.grey
                                      ),),
                                      _buildEmail(),
                                      SizedBox(height: 50,),
                                      SizedBox(
                                          width: 268,
                                          height: 61,
                                          child: Obx(() => ElevatedButton(
                                                onPressed:
                                                    controller.btnState.value
                                                        ? () => resetPasswordProcess()
                                                        : null,
                                                child: Text(
                                                  'Submit',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Theme.of(context)
                                                          .buttonColor),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                    primary:
                                                        Themes.darkButton1Color,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10))),
                                              ))),
                                    ],
                                  ),
                                ),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                    text: "Already have an account?",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2, color: Theme.of(context).dividerColor),
                                  ),
                                  TextSpan(
                                      text: " Login",
                                      recognizer: new TapGestureRecognizer()
                                        ..onTap = () => {
                                              //print("testing one two three"),
                                              //setState(() => loading = true),
                                              nullPreferences(),
                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  '/LoginSignUp/login',
                                                  (r) => false)
                                            },
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13,
                                          fontFamily: 'Montserrat-Regular',
                                          letterSpacing: 0.2, color: Themes.darkButton2Color),),
                                ]),
                              ),
                              SizedBox(height: 30)
                            ],
                          ),
                        )),
                      ),
                    );
                  },
                )),
          );
  }
  //on reset button click validate input, show loading screen and call resetPassword()
  resetPasswordProcess() {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() => loading = true);
      _formKey.currentState.save();
      print("EMAIL EAMIL resetPassword: " + _emailFromLogin);
      print(_emailFromLogin);
      print("email below");
      print(_email);
      resetPassword(_email);

      // resetPassword(_email.toLowerCase());
    }
  }
  //sets sharedPreferences to null on already have account login button click
  nullPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
  //called in resetPasswordProcess when reset button is clicked, saves email in sharedPreferences and goes to new view
  resetPassword(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/LoginSignUp/resetPasswordConfirm',
      (r) => false,
      arguments: {'email': _email},
    );
  }
}
