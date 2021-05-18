import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:topshottimer/Themes.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:topshottimer/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:topshottimer/global.dart';
import '../../Themes.dart';

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

//CONTENTS
//  4 X Widget
//  4 X Method
class SignUpState extends  State<SignUp> {
  //variable declarations
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _emailFromLogin;
  bool _passwordVisible = false;
  bool _loading = false;
  FocusNode _focusNode = FocusNode();
  //form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //access global variables in global.dart
  final controller = Get.put(Controller());
  //allows the accepting of data from another view
  SignUpState(this._emailFromLogin);
  //following 5 widgets are inputs for user information with validation
  //first name input and validation
  Widget _buildFirstName() {
    final node = FocusScope.of(context);
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'First Name',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'Montserrat-Regular',
              letterSpacing: 0.2, color: Colors.grey),
        prefixIcon: Icon(Icons.perm_identity, color: Theme.of(context).iconTheme.color),
      ),
      //allows the keyboard function to go to next textfield or close keyboard
      onEditingComplete: () => node.nextFocus(),
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          //saveData(context);
          return 'Required';
        }
        //regex to check for white spaces
        if(RegExp(r"\s+").hasMatch(value)){
          return 'White spaces not allowed';
        }
        //regex only allowing letters
        if (!RegExp(
            r"^([a-zA-Z]+?)$")
            .hasMatch(value)) {
          return 'Only letters allowed';
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
    final node = FocusScope.of(context);
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Last Name',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'Montserrat-Regular',
              letterSpacing: 0.2, color: Colors.grey),
        prefixIcon: Icon(Icons.perm_identity, color: Theme.of(context).iconTheme.color),
      ),
      onEditingComplete: () => node.nextFocus(),
      textInputAction: TextInputAction.next,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
        }
        //regex to check for white spaces
        if(RegExp(r"\s+").hasMatch(value)){
          return 'White spaces not allowed';
        }
        //regex only allowing letters
        if (!RegExp(
            r"^([a-zA-Z]+?)$")
            .hasMatch(value)) {
          return 'Only letters allowed';
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
    final node = FocusScope.of(context);
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
          labelStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              fontFamily: 'Montserrat-Regular',
              letterSpacing: 0.2, color: Colors.grey),
          prefixIcon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),
      ),
      //allows the keyboard function to go to next textfield or close keyboard
      onEditingComplete: () => node.nextFocus(),
      textInputAction: TextInputAction.next,
      initialValue: _emailFromLogin,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Required';
        }
        //regex to check for white spaces
        if(RegExp(r"\s+").hasMatch(value)){
          return 'White spaces not allowed';
        }
        //regex makes sure that it contains a @gmail.com of some sort
        if (!RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
          return 'Invalid email address';
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
    final node = FocusScope.of(context);
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password',
          labelStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            fontFamily: 'Montserrat-Regular',
            letterSpacing: 0.2, color: Colors.grey),
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
              Timer.run(() => _focusNode.unfocus());
            },
      ),
      ),
      onEditingComplete: () {
        // Move the focus to the next node explicitly.
        FocusScope.of(context).nextFocus();
      },
      //allows the keyboard function to go to next textfield or close keyboard
      onFieldSubmitted: (_) => node.unfocus(),
      textInputAction: TextInputAction.done,
      focusNode: _focusNode,
      obscureText: !_passwordVisible,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password cant be empty';
        }
        //password must be 6 characters or more
        if(value.length <=6){
          return "Must be 6+ characters";
        }
        //regex to check for white spaces
        if(RegExp(r"\s+").hasMatch(value)){
          return 'White Spaces not Allowed';
        }
        //regex to check strength of password
        if (!RegExp(
            r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$")
            .hasMatch(value)) {
          return 'Password not strong';
        }
        return null;
      },
      onChanged: (String value){
        _password = value;
      },
      onSaved: (String value) {
        _password = value;
      },
    );
  }
  //main view with all widgets combined
  @override
  Widget build(BuildContext context) {
    //dsiplays loading screen when set state is true
    return _loading ? Loading() : KeyboardDismisser(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Sign Up", style: TextStyle(color: Colors.white)), iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),),
        //allows for the movement of widget to not be blocked by the keyboard
        //Custom and Silver are used because singlechildscrollview dose not work with expanded
        body: LayoutBuilder(
          builder: (context, constraint) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraint.maxHeight),
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
                            _buildFirstName(),
                            SizedBox(height: 15),
                            _buildLastName(),
                            SizedBox(height: 15),
                            _buildEmail(),
                            SizedBox(height: 15),
                            _buildPassword(),
                            SizedBox(height: 45),
                        SizedBox(
                          width: 268,
                          height: 61,
                          child: Obx(() => ElevatedButton(onPressed: controller.btnState.value ?
                              () => signUpProcess() :
                          null,
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  fontFamily: 'Montserrat-Regular',
                                  letterSpacing: 0.2,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(primary: Themes.darkButton1Color, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                          )
                        )
                        ),
                          ],
                        ),
                ),
                      ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(children: <TextSpan>[
                      TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(fontWeight: FontWeight.w300,
                            fontSize: 13,
                            fontFamily: 'Montserrat-Regular',
                            letterSpacing: 0.2, color: Theme.of(context).dividerColor),

                      ),
                      TextSpan(
                          text: " Login",
                          recognizer: new TapGestureRecognizer()
                            ..onTap = () =>
                            {
                              nullPreferences(),
                              Navigator.pushNamedAndRemoveUntil(
                                  context, '/LoginSignUp/login', (
                                  r) => false)
                            },
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 13,
                              fontFamily: 'Montserrat-Regular',
                              letterSpacing: 0.2, color: Themes.darkButton2Color),)
                    ]),
                  ),
                      SizedBox(height:30)
                    ],
                  ),
                  )
                ),
              ),
            );
          },
        )
      ),
    );
  }
  //sign up button
  signUpProcess(){
    if (!_formKey.currentState.validate()) {
      return;
    }
    nullPreferences();
    _formKey.currentState.save();
    _firstName =
        StringUtils.capitalize(_firstName);
    _lastName =
        StringUtils.capitalize(_lastName);

    sendData(_firstName.replaceAll(
        new RegExp(r"\s+"), ""),
        _lastName.replaceAll(
            new RegExp(r"\s+"), ""),
        _email.replaceAll(
            new RegExp(r"\s+"), "")
            .toLowerCase(),
        _password.replaceAll(
            new RegExp(r"\s+"), ""));
  }
  //when signing up reset sharedPreferences and when clicking already have account login
  nullPreferences()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
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
      var res = await post(
          Uri.parse(url), headers: {"Accept": "application/jason"},
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
         //saveUserInformation(id, email, hashedPassword, "false", firstName, lastName);
         print(id);
         print(email);
         print("saving user information!!");
         SharedPreferences prefs = await SharedPreferences.getInstance();
         await prefs.setString('id', id);
         await prefs.setString('email', email);
         await prefs.setString('password', hashedPassword);
         await prefs.setString('verify', status);
         await prefs.setString('firstName', firstName);
         await prefs.setString('lastName', lastName);
         await prefs.setBool('loginBefore', false);
         print("email in signup");
         print(email);
         print(prefs.getString('email'));
         print("DONE SAVING USER INFORMATION");
         Navigator.pushNamedAndRemoveUntil(context, '/LoginSignUp/verifyEmail', (r) => false ,arguments: {'email': email}, );
      } else if(id != "" && status == "user"){
        //print("this is a user");
        setState(() => _loading = false);
        //saveUserInformation(id, email, hashedPassword, "true", firstName, lastName);
        //show dialog
        accountInUseDialog();
      }
    } on TimeoutException catch (e) {
  print('Timeout Error: $e');
  } on SocketException catch (e) {
  print('Socket Error: $e');
  } on Error catch (e) {
  print('General Error: $e');
  }
  }
  //account email is already used
  accountInUseDialog(){
    Dialog dialog = new Dialog(
        backgroundColor: Themes.darkBackgoundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
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
                    Text("Account already in use", style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    fontFamily: 'Montserrat-Regular',
                    letterSpacing: 0.2, color: Colors.white),),
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
                                color: Themes.darkButton2Color,
                              ),
                              height: 45,
                              child: Center(
                                child: Text("Confirm",
                                    style: TextStyle(fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat-Regular',
                                        letterSpacing: 0.2, color: Colors.white),),
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
                    child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                )
            ),
          ],
        )
    );
    //shows dialog since it's inside a method
    showDialog(context: context, builder: (context) => dialog);
  }
}

