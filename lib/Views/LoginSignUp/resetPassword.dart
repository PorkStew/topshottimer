import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  final email = TextEditingController();
  _resetPasswordState(this.emailFromLogin);
  Widget _buildEmail() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      controller: email,

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

           // child: Text("Password Reset!", style: TextStyle(
           //   fontSize: 40,
           // ),)

          ),
          Container(
            padding: EdgeInsets.only(top: 150,bottom: 15,left: 35, right: 35),
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
                          child: Text('Submit',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () {
                            print("email below");
                            print(email.text);
                            resetPassword(email.text);
                          },
                          color: Colors.red,
                        ),
                        ),
                      ],
                    ),
                  )
                ]
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
      print(email);
      var url = 'https://www.topshottimer.co.za/mailer2.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            "emailAddress": email,
          }
      );
      // saveUserInformation(id, email, hashedPassword);
      //decodes incoming php data
      // Map<String, dynamic> data = json.decode(res.body);
      // String id = data['id'];
      // String status = data["status"];
      // print(id);
      // print(status);

    }catch (error) {
      print(error.toString());
    }
  }
  Future createMessage(){

    AlertDialog alert = AlertDialog(
      title: Text("Email with instructions has been sent!"),
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
