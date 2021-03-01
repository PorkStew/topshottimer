import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPasswordConfirm.dart'
    as con;
import 'package:topshottimer/Views/LoginSignUp/login.dart' as login;
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/loading.dart';
import 'package:topshottimer/global.dart';

class ResetPassword extends StatefulWidget {
  String something = "";

  ResetPassword(this.something);

  @override
  State<StatefulWidget> createState() {
    //need to accept a aurgement
    return _ResetPasswordState(this.something);
  }
}

class _ResetPasswordState extends State<ResetPassword> {
  String _email;
  String _emailFromLogin;
  bool loading = false;

  _ResetPasswordState(this._emailFromLogin);

  final controller = Get.put(Controller());
  final email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  //email input and validation
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
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
                //Custom and Silver are used because singlechildscrollview dose not work with expanded
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
                                      SizedBox(height: 10),
                                      Text("Forgot your password?", style: TextStyle(
                                          fontSize: 25
                                      ),),
                                      Text("Confirm your email and we'll send the instructions.", textAlign: TextAlign.center, style:  TextStyle(
                                          fontSize: 17
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
                                        color: Theme.of(context).dividerColor),
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
                                          color: Themes.darkButton2Color,
                                          fontWeight: FontWeight.bold)),
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

  nullPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

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
//REMOVE
// resetPassword(String email) async{
//   try{
//     var url = 'https://www.topshottimer.co.za/resetPasswordMailer.php';
//     var res = await http.post(
//         Uri.encodeFull(url), headers: {"Accept": "application/jason"},
//         body: {
//           "emailAddress": email,
//         }
//     );
//     //Navigator.of(context).pop();
//     //Navigator.push(context, MaterialPageRoute(builder: (context) => con.resetPasswordConfirm(email)));
//     //Navigator.pushNamedAndRemoveUntil(context, '/LoginSignUp/resetPasswordConfirm', (r) => false ,arguments: {'email': email});
//
//   }catch (error) {
//     print(error.toString());
//     setState(() => loading = false);
//   }
// }
}
