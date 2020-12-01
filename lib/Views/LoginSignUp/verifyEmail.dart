import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/PageSelector.dart' as pageSelector;
import 'package:http/http.dart' as http;

class verifyEmail extends StatefulWidget {

  String incomingEmail = '';
  verifyEmail(this.incomingEmail);

  @override
  State<StatefulWidget> createState() {
    //accepts email argument to display as text to user
    return _verifyEmailState(this.incomingEmail);
  }
}

class _verifyEmailState extends State<verifyEmail> {
  //variable declaration
  String emailAddress = '';
  int count = 0;
  //get incoming variable
  _verifyEmailState(this.emailAddress);

  @override
  void initState(){
    super.initState();
    //check if user is verified or send email verification link
    getUserInfo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 15, left: 0, right: 0),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: ClipRRect(
                          child: Image.asset(
                            "assets/mail-1454734_1920.png",
                            width: 180,
                          )),
                    ),
                    Text("Email Verification Required", textAlign: TextAlign.center, style:  TextStyle(
                        fontSize: 40
                    ),),
                    Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        children: [
                          Text("An email has been sent to:", textAlign: TextAlign.center, style:  TextStyle(
                              fontSize: 17,
                          ),),
                          Text(emailAddress, style:  TextStyle(
                              fontSize: 17,
                          ),),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Please follow the instructions in the verification email to finish creating your Top Shot Timer account.", textAlign: TextAlign.center, style:  TextStyle(
                              fontSize: 17,
                          ),),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          RichText(
                              text: TextSpan(
                                  text: "Didn't receive an email?",
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                        print("resend email here");
                                        getUserInfo();
                                    }
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 50, bottom: 15, left: 0, right: 0),
                child: Column(
                  children: [
                    SizedBox(
                        width: 250,
                        height: 40,
                       child: RaisedButton(
                          onPressed: (){
                            print("df");
                            checkUserVerified();
                          },
                          child: Text(
                              'CHECK ACCOUNT STATUS',
                            style: TextStyle(color: Colors.black, fontSize: 15),

                          ),
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                        )
                    ),
                  ],
                ),
              )
            ],
          ),
        )
    );
  }
  //this called auto on page oad or when user clicks button
  getUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    print("email here");
    print(email);
    try{
      var url = 'https://www.topshottimer.co.za/mailerVerifyEmail.php';
      var res = await http.post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //TODO uncomment when testing is complete
            "emailAddress": email,
          }
      );
      Map<String, dynamic> data = json.decode(res.body);
      String status = data["status"];
      print("the following is the users status: " + status);
      if(status == "nonverified" && count != 0) {
        emailSent();
      }
      count++;
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
  checkUserVerified() async{
    //String hashedPassword = "";
   // var bytes = utf8.encode(password);
   // var digest = sha256.convert(bytes);
   // hashedPassword = digest.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    String password = await prefs.getString('password');
    String verified = await prefs.getString('verify');
    if(verified == 'true'){
    //TODO: go to home page
      Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    }
    var url = 'https://www.topshottimer.co.za/checkUserIsVerified.php';
    var res = await http.post(
        Uri.encodeFull(url), headers: {"Accept": "application/jason"},
        body: {
          //get this information from user defaults
          "emailAddress": email,
          "password": password,
        }
    );
    print("before res.body");
    Map<String, dynamic> data = json.decode(res.body);
    //String id = data['id'];
    String status = data["verified"];
    //print("ss");
    //print(id);
    print(status);
    //print("dddd");
    //display message because they are not a user
    if (status == "error") {
      print("we don't have this user");
      //TODO should we not just return to login if there is no user
    }
    //is a user but they haven't verified their email address
    else if (status == "false") {
      await prefs.setString('verify', "false");
      print("we have this user but they are not verified");
      print("email not verified");
      notVerifiedError();
      //saveUserInformation(id, email, hashedPassword);
     // Navigator.push(context, MaterialPageRoute(builder: (context) => verify.verifyEmail()));
    }
    //is a user and is veried email so they can use the app
    else if (status == "true") {
      print("user details is all in order");
      await prefs.setString('verify', "true");
      //saveUserInformation(id, email, hashedPassword);
      Navigator.push(context, MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    } else{

    }
  }

  getEmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    emailAddress = email;
  }
  emailSent(){
    SimpleDialog carDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Email Sent!", style: TextStyle(fontSize: 20),),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: (){
                      print("OKAY");
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(6), bottomRight:  Radius.circular(6)),
                        color: Colors.red,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("OKAY",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
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
  notVerifiedError(){
    SimpleDialog carDialog = SimpleDialog(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      children: <Widget>[
        Column(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Text("Account not verified!", style: TextStyle(fontSize: 20),),
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
                        color: Colors.red,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("TRY AGAIN",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      print("SIGN UP");
               getUserInfo();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(6)),
                        color: Colors.blueAccent,
                      ),
                      height: 45,
                      child: Center(
                        child: Text("SEND EMAIL",
                            style: TextStyle(color: Colors.black, fontSize: 20)),
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


