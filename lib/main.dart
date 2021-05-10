import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/Scores/Profile.dart';
import 'package:topshottimer/Views/Settings/Settings.dart';
import 'package:topshottimer/Views/Settings/editUserDetails.dart';
import 'package:topshottimer/Views/Timer/timer.dart';
import 'dart:convert';
import 'package:topshottimer/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'package:topshottimer/Views/PageSelector.dart';
import 'package:topshottimer/Views/LoginSignUp/login.dart';
import 'package:topshottimer/Views/LoginSignUp/resetPasswordConfirm.dart';
import 'package:topshottimer/Views/LoginSignUp/verifyEmail.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get/get.dart';
import 'package:topshottimer/global.dart';
import 'package:topshottimer/pricing.dart';

//TODO remove prints when beta and release
void main() {
  runApp(MyApp());
}
//themes and routes
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Top Shot Timer',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: CheckUserDetails(),
      debugShowCheckedModeBanner: false,
      //system locations for views that are accessed through pushReplacementNamed and GET plugin
      routes: {
        '/LoginSignUp/login': (context) => Login(),
        '/PageSelector': (context) => pageSelector(),
        '/LoginSignUp/resetPasswordConfirm': (context) =>
            ResetPasswordConfirm(),
        '/LoginSignUp/verifyEmail': (context) => verifyEmail(),
        'Settings/editUserDetails': (context) => editUserDetails(),
        'Timer/Timer': (context) => TimerPage(),
        'Scores/Profile': (context) => Profile(),
        'Settings/Settings': (context) => Settings(),
      },
    );
  }
}

class CheckUserDetails extends StatefulWidget {
  @override
  _CheckUserDetailsState createState() => _CheckUserDetailsState();
}

class _CheckUserDetailsState extends State<CheckUserDetails> {
  //variable declaration
  bool _loading = true;
  bool _hasConnection = false;
  Future _noInternetConnectionDialogFuture;
  final _controller = Get.put(Controller());

  @override
  void initState() {
    super.initState();
    //checks continually every 1 second for internet connection
    //to change delay go to Dart Packages/data_connection_checker-version/data_connection_checker.dart
    //DataConnectionChecker().connectionStatus = true;
    //DataConnectionStatus.connected;
    DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        //has internet connection
        case DataConnectionStatus.connected:
          print('success there is internet');
          //firstRebuild for GET tells the system to update the value when it's either true or false. By default that get works is that if the default value is false then we say a new value is false then it won't update any place the variable is used
          _controller.btnState.firstRebuild = false;
          _controller.btnState.value = true;
          _hasConnection = true;
          // setInternet(true);
          checkUserInformation(context);
          break;
        //no internet which setts button states to disabled and shows dialog
        case DataConnectionStatus.disconnected:
          print("No internet connection");
          _controller.btnState.firstRebuild = false;
          _controller.btnState.value = false;
          _hasConnection = false;
          _noInternetConnectionDialogFuture = _noInternetConnectionDialog();
      }
    });
  }

  //check if they have logged in before and go to either login.dart or pageSelector.dart and show no Internet dialog
  _noInternetConnectionDialog() async {
    bool _loggedInBefore = false;
    //checks SharedPreferences to see if they have logged in before
    _loggedInBefore = await offlineProcess();
    //if they have logged in before show pageSelector.dart
    if (_loggedInBefore != false) {
      Get.off(pageSelector());
    } else if (Get.currentRoute == "/Login") {
    } else {
      Get.off(Login());
    }
    //No Internet Dialog
    Get.dialog(Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              //this will affect the height of the dialog
              height: 230,
              child: Padding(
                //play with top padding to make items fit
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(children: [
                        Text(
                          "Whoops!",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No internet connection found. Without an internet connection certain features will be disabled.",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ]),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              //Navigator.pop(context);
                              Get.back();
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
                                child: Text("Confirm",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white)),
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
        )));
  }

  //loading screen which is called from loading.dart
  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Container();
  }
}

//acts like a auto login system that will check if shared preferences has user information and will show a screen depending on that information
checkUserInformation(context) async {
  Get.back();
  print('MAIN.DART');
  //get user information
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String _id = prefs.getString('id');
  String _email = prefs.getString('email');
  String _hashedPassword = prefs.getString('password');
  String _verified = prefs.getString('verify');
  print("The Following is user details");
  print(_id);
  print(_email);
  print(_hashedPassword);
  print(_verified);
  print("DONE USER DETAILS!!!!");
  try {
    //checks the validity shared preference information is not empty, then will try login
    if (_id != null &&
        _email != null &&
        _hashedPassword != null &&
        _verified != null) {
      var url = 'https://www.topshottimer.co.za/login.php';
      var res = await post(Uri.parse(url), headers: {
        "Accept": "application/jason"
      }, body: {
        //get this information from user shared preferences
        "emailAddress": _email,
        "password": _hashedPassword,
      });

      //data is then received from the php file indicating user state
      //status can either be verified / non-verified or not-user
      Map<String, dynamic> data = json.decode(res.body);
      String _id = data['id'];
      String _status = data["status"];
      String _firstName = data["firstName"];
      String _lastName = data["lastName"];
      print("We received the following data!");
      print(_id);
      print(_status);
      print(_firstName);
      print(_lastName);
      print("END OF RECEIVING DATA!!!");

      //not a user
      if (_status == "not-user") {
        print("MAIN.DART END*******************************");
        await prefs.setBool('loginBefore', false);
        Get.off(Login());
      }
      //is a user but has not verified their email yet
      else if (_status == "non-verified" && _id != null) {
        await prefs.setString('id', _id);
        await prefs.setString('verify', 'false');
        await prefs.setString('firstName', _firstName);
        await prefs.setString('lastName', _lastName);
        await prefs.setBool('loginBefore', false);
        print("MAIN.DART END*******************************");
        Get.off(verifyEmail(), arguments: {'email': _email});
        //is a user and account is verified
      } else if (_status == "verified" && _id != null) {
        await prefs.setString('id', _id);
        await prefs.setString('verify', 'true');
        await prefs.setString('firstName', _firstName);
        await prefs.setString('lastName', _lastName);
        await prefs.setBool('loginBefore', true);
        print("MAIN.DART END*******************************");
        Get.off(pageSelector());
      }
      //no shared preference data is found go to login
    } else {
      Get.off(Login());
      print("MAIN.DART END*******************************");
    }
  } on TimeoutException catch (e) {
    print('Timeout Error: $e');
  } on SocketException catch (e) {
    print('Socket Error: $e');
  } on Error catch (e) {
    print('General Error: $e');
  }
}

//checks if the user has logged in before which means they have account details and they are correct.
offlineProcess() async {
  bool _loginBefore = false;
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _loginBefore = prefs.getBool('loginBefore');
    if (_loginBefore == null) {
      return false;
    }
    return _loginBefore;
  } catch (exception) {
    print(exception);
    return _loginBefore;
  }
}
