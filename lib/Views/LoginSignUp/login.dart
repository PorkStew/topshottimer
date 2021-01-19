import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/LoginSignUp/signup.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPassword.dart';
import 'package:topshottimer/loading.dart';
//TODO we don't need controllers any mroe
class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
   String test = "s";

  //variable declarations
  int _count = 0;
  //amount should be 6 for when user should be asked if they don't have an account to sign up
  int _whenToDisplay = 6;
  bool _passwordVisible = false;
  bool loading = false;
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
    return loading? Loading() :  Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        //physics: NeverScrollableScrollPhysics(),

        //margin: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Container(
           // decoration: BoxDecoration(
            //  image: DecorationImage(

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
                       "assets/target-green@3x.png",
                       width: 130,
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
                SizedBox(height: 20),
                Center(

                  child:  RichText(
                        text: TextSpan(
                            text: "Forgot your password?",
                            style: TextStyle(color: Colors.blueAccent),
                            recognizer: new TapGestureRecognizer()
                              ..onTap = () {
                              //TODO change this i think
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                       builder: (context) => ResetPassword(_email.text))
                                );
                              })),

                ),
                SizedBox(height: 30),
                SizedBox(
                    width: 268,
                    height: 60,
                    child: RaisedButton(
                      child: Text(
                        'Login',
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
                  height: 26,
                ),
                SizedBox(
                    width: 268,
                    height: 60,
                    child: RaisedButton(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20, color: Theme.of(context).buttonColor),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUp(_email.text)));
                      },
                      color: Themes.PrimaryColorBlue,
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
    print("hello");
    setState(() => loading = true);
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
    print("hello123");
    Map<String, dynamic> data = json.decode(res.body);
    String id = data['id'];
    String status = data["status"];
    String firstName = data["firstName"];
    String lastName = data["lastName"];

    //display message because they are not a user
    if (status == "not-user") {
      setState(() => loading = false);
      _count++;
      if(_count < _whenToDisplay){
        print("hello1");
        setState(() => loading = false);
        incorrectDetailsDialog();
        return;
      } else {
        print("hello2");
        setState(() => loading = false);
        createAccountDialog();
        _count = 0;
        return;
      }
    }
    //is a user but they haven't verified their email address
    else if (status == "non-verified" && id != null) {
      print("helloasdasdasdasasdasdasdasdasdasd");
      saveUserInformation(id, email, hashedPassword, "non-verified", firstName, lastName);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => verify.verifyEmail(email)));
      Navigator.pushReplacementNamed(context, '/LoginSignUp/verifyEmail', arguments: {'email': email});
    }
    //is a user and is verified email so they can use the app
    else if (status == "verified" && id != null) {
      saveUserInformation(id, email, hashedPassword, "verified", firstName, lastName);
      //Navigator.of(context).pushReplacementNamed('/PageSelector');
      print("where do i go from here");
      Navigator.pushReplacementNamed(context, '/PageSelector');
      //Navigator.push(context,
          //MaterialPageRoute(builder: (context) => pageSelector.pageSelector()));
    } else {
      print("hello3");
      setState(() => loading = false);
    }
  }

//takes the users information and stores it in shared preferences
  saveUserInformation(var id, String email, String hashedPassword, String status, String firstName, String lastName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('email', email);
    await prefs.setString('password', hashedPassword);
    await prefs.setString('verify', status);
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    print(firstName);
    print(lastName);

  }

  incorrectDetailsDialog(){
    Dialog dialog = new Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          overflow: Overflow.visible,
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
                    Text("Incorrect Details!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 20,),
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
                                BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 40,
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    showDialog(context: context, builder: (context) => dialog);
  }



  createAccountDialog() {
    Dialog dialog = new Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(
          overflow: Overflow.visible,
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
                    Text("Having Trouble?", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    Text("Don't feel left out, Sign up now!", style: TextStyle(fontSize: 17),textAlign: TextAlign.center,),
                    SizedBox(height: 20,),
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
                                BorderRadius.only(bottomLeft: Radius.circular(10)),
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
                              // Navigator.pop(context);
                              //Navigator.push(context,
                              // MaterialPageRoute(builder: (context) => SignUp(_email.text)));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.only(bottomRight: Radius.circular(10)),
                                  //color: Themes.PrimaryColorRed,
                                  color: Colors.amber
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
              ),
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 40,
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    showDialog(context: context, builder: (context) => dialog);
  }
}

