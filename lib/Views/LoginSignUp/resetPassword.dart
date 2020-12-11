import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/Views/LoginSignUp/resetPasswordConfirm.dart' as con;
import 'package:topshottimer/Themes.dart';
class resetPassword extends StatefulWidget {
  String something = "First Name";
  resetPassword(this.something);

  @override
  State<StatefulWidget> createState() {
    //need to accept a aurgement
    return _resetPasswordState(this.something);
  }
}

class _resetPasswordState extends State<resetPassword> {

  String _email;
  String emailFromLogin;
  _resetPasswordState(this.emailFromLogin);
  final email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //email input and validation
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'EMAIL',
        prefixIcon: Icon(Icons.email, color: Theme.of(context).iconTheme.color,),

      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Password Reset")),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.only(top: 50,bottom: 15,left: 0, right: 0),
           child: Column(
             children: <Widget>[
               Container(
                 alignment: Alignment.center,
                 child: ClipRRect(
                     child: Image.asset(
                       "assets/lock.png",
                       width: 180,
                     )),
               ),
               SizedBox(height: 10),
               Text("Forgot your password?", style: TextStyle(
                 fontSize: 25
               ),),
               Container(
                 padding: EdgeInsets.only(top: 15),
                child: Column(
                  children: <Widget> [
                    Text("Confirm your email and we'll send the instructions.", style:  TextStyle(
                        fontSize: 15
                    ),),
                  ],
                ),
               )
             ],
           )
          ),
          Container(
            padding: EdgeInsets.only(top: 13,bottom: 15,left: 35, right: 35),
              child: Form(
                key: _formKey,
                child: Column(
                children: <Widget>[
                  _buildEmail(),
                  Container(
                    padding: EdgeInsets.only(top: 15),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20,),
                        SizedBox(
                          width: 250,
                          height: 40,
                        child: RaisedButton(
                          child: Text('SUBMIT',
                            style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
                          ),
                          onPressed: () {
                            if (!_formKey.currentState.validate()) {
                              return;
                            } else {
                              _formKey.currentState.save();
                              print("EMAIL EAMIL resetPassword: " + emailFromLogin);
                              print(emailFromLogin);
                              print("email below");
                              print(_email);
                              resetPassword(_email);
                            }
                          },
                          color: Themes.PrimaryColorRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        ),
                      ],
                    ),
                  )
                ]
                  ),
              )
          ),
        ],
      //     margin: EdgeInsets.all(24),
      //     child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //       children: <Widget> [
      //
      //         _buildEmail(),
      //         RaisedButton(
      //           child: Text(
      //             'Submit',
      //             style: TextStyle(color: Colors.blue, fontSize: 16),
      //           ),
      //           onPressed: () {
      //             resetPassword(email.text);
      //             //Send to API
      //             //send user information to the database
      //             //sendData(_firstName, _lastName, _email, _password);
      //           },
      //         )
      //       ],
      //     )
      )
    );
  }
  resetPassword(String email) async{
   // SharedPreferences prefs = await SharedPreferences.getInstance();
   // String email = await prefs.getString('email');
    //String email = 'stewartclay166@gmail.com';
    try{
      var url = 'https://www.topshottimer.co.za/mailer2.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "emailAddress": email,
          }
      );
      //Navigator.of(context).pop();
      //Navigator.push(context, MaterialPageRoute(builder: (context) => con.resetPasswordConfirm(email)));
      Navigator.pushReplacementNamed(context, '/LoginSignUp/resetPasswordConfirm', arguments: {'email': email});

    }catch (error) {
      print(error.toString());
    }
  }
}
