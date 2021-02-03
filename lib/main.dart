import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:topshottimer/Themes.dart';
import 'package:topshottimer/Views/Profile.dart';
import 'package:topshottimer/Views/timer.dart';
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
import 'Views/Settings.dart';
import 'Views/editUserDetails.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//TODO: check shared preferences and the naming
//TODO: add a loading screen to the sign up when going to verifyemail
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Top Shot Timer',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      home: CheckUserDetails(),
      debugShowCheckedModeBanner: false,
      //tells the system the locations for views that are accessed through pushReplacementNamed
      routes: {
        '/LoginSignUp/login': (context) => Login(),
        '/PageSelector': (context) => pageSelector(),
        '/LoginSignUp/resetPasswordConfirm': (context) => ResetPasswordConfirm(),
        '/LoginSignUp/verifyEmail': (context) => verifyEmail(),
        '/editUserDetails': (context) => editUserDetails(),
        '/Timer': (context) => TimerPage(),
        '/Profile': (context) => Profile(),
        '/Settings': (context) => Settings(),
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
  bool hasConnection = false;
  Future noInternetConnectionDialogFuture;
  @override
  void initState() {
    super.initState();
    //checks continually every 1 second for internet connection
    //to change delay go to Dart Packages/data_connection_checker-version/data_connection_checker.dart
    DataConnectionChecker().onStatusChange.listen((status) {
        switch(status){
          //has internet connection
          case DataConnectionStatus.connected:
            print('success there is internet');
             hasConnection = true;
            //_loading = false;
            setInternet(true);
            checkUserInformation(context);
            break;
            //no internet
          case DataConnectionStatus.disconnected:
            print("No internet connection");
            hasConnection = false;
            noInternetConnectionDialogFuture = _noInternetConnectionDialog();
        }
    });
  }
  _noInternetConnectionDialog() async{
    print('inside no internet redirect');
    testFuture = await offlineProcess();
    print(testFuture);
    if(testFuture != false){
      print('SHOWING PAGESELECTOR');
      // Navigator.pushReplacementNamed(context, '/PageSelector');
      //Get.toNamed('/PageSelector');
      Get.off(pageSelector());
    } else {
      print('SHOWING LOGIN');
      //Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
      //Get.toNamed('/LoginSignUp/login');
      Get.off(Login());
    }
    print('showing dialog for no internet');

    Get.dialog(
        Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
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
                        Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10,0),
                          child: Column(
                              children: [
                                Text("Whoops!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                                SizedBox(height: 20,),
                                Text("No internet connection found. Without an internet connection certain features will be disabled.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),textAlign: TextAlign.center,),
                                SizedBox(height: 20,),
                              ]
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  //Navigator.pop(context);
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
                        backgroundColor: Themes.darkButton2Color,
                        radius: 40,
                        child: Image.asset("assets/Exclamation@3x.png", height: 53,)
                    )
                ),
              ],
            )
        ));
  }
  bool testFuture;
  //loading screen
  @override
  Widget build(BuildContext context) {
    return _loading ? Loading() : Container();
  }
}
setInternet(bool hasInternet) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('internet', hasInternet);
}

//acts like a auto login system that will check if shared preferences has user information and will show a screen depending on that information
checkUserInformation(context) async {
  Get.back();
  print('MAIN.DART');
  //get user information
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = prefs.getString('id');
  String email =  prefs.getString('email');
  String hashedPassword = prefs.getString('password');
  String verified = prefs.getString('verify');
  print("The Following is user details");
  print(id);
  print(email);
  print(hashedPassword);
  print(verified);
  print("DONE USER DETAILS!!!!");
  try{
  //checks the validity shared preference information is not empty, then will try login
    if(id != null && email != null && hashedPassword != null && verified != null) {
      var url = 'https://www.topshottimer.co.za/login.php';
      var res = await post(
          Uri.encodeFull(url), headers: {"Accept": "application/jason"},
          body: {
            //get this information from user shared preferences
            "emailAddress": email,
            "password": hashedPassword,
          }
      );

      //data is then received from the php file indicating user state
      //status can either be verified / non-verified or not-user
      Map<String, dynamic> data = json.decode(res.body);
      String id = data['id'];
      String status = data["status"];
      String firstName = data["firstName"];
      String lastName = data["lastName"];
      print("We recived the following data!");
      print(id);
      print(status);
      print(firstName);
      print(lastName);
      print("END OF RECIVING DATA!!!");

      //not a user
      if (status == "not-user") {
        print("MAIN.DART END*******************************");
       // Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
        await prefs.setBool('loginBefore', false);
        //Get.toNamed('/LoginSignUp/login');
        Get.off(Login());
      }
      //is a user but has not verified their email yet
      else if (status == "non-verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'false');
        await prefs.setString('firstName', firstName);
        await prefs.setString('lastName', lastName);
        await prefs.setBool('loginBefore', false);
        print("MAIN.DART END*******************************");
        //Get.toNamed('/LoginSignUp/verifyEmail', arguments: {'email': email});
        Get.off(verifyEmail(), arguments: {'email': email});
        //Navigator.pushReplacementNamed(context, '/LoginSignUp/verifyEmail', arguments: {'email': email});
        //if details are in the database and user email is verified
      } else if (status == "verified" && id != null) {
        await prefs.setString('id', id);
        await prefs.setString('verify', 'true');
        await prefs.setString('firstName', firstName);
        await prefs.setString('lastName', lastName);
        await prefs.setBool('loginBefore', true);
        print("MAIN.DART END*******************************");
        //Navigator.pushReplacementNamed(context, '/PageSelector');
        //Get.toNamed('/PageSelector');
        Get.off(pageSelector());
        //Navigator.pushReplacementNamed(context, '/LoginSignUp/login');
      }
      //no shared preference data is found go to login
    } else{
      //Get.toNamed('/LoginSignUp/login');
      Get.off(Login());
      //Navigator.pushReplacementNamed(context, '/LoginSignUp/login');

      //Navigator.pushReplacementNamed(context, routeName)

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => Login()));
      //Navigator.push(context, Dialog());
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
offlineProcess() async{
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // await prefs.setBool('loginBefore', false);
  print('offlineProcess');
  bool loginBefore = false;
  try {
    print('okay');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginBefore = prefs.getBool('loginBefore');
    //print(false);
    if(loginBefore == null){
      return false;
    }
    //print(loginBefore.toString());
    return loginBefore;
  } catch(exception){
    print('error');
    print(exception);
    //print(loginBefore.toString());
    return loginBefore;
  }


}