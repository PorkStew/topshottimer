import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:topshottimer/Views/Subscription/pricing.dart';
import 'package:topshottimer/global.dart';
import '../../Themes.dart';

String userGetID;

class Splits extends StatefulWidget {
  String sTest;

  Splits(this.sTest);

  @override
  State<StatefulWidget> createState() {
    return SplitsState(
      this.sTest,
    );
  }
}

class SplitsState extends State<Splits> {
  //Controller decleration for checking internet connection

  final controller = Get.put(Controller());
  final _controller = Get.put(Controller());

  //Variable initialisation
  String sEnteredName;
  String sHelloWorld;

  SplitsState(this.sHelloWorld);

  List<String> strings;
  List<String> arrShots = [];
  final sUserInput = TextEditingController();

  @override
  void initState() {
    Purchases.getPurchaserInfo();
    obtainUserDefaults();
    //Replaces commas in data recieved from database
    sHelloWorld.replaceAll(' ', '');
    print(sHelloWorld);
    final removedBrackets = sHelloWorld.substring(1, sHelloWorld.length - 1);
    strings = removedBrackets.split(",");
    String sToTruncate;

    //Trims the array values

    for (var i = 0; i <= strings.length - 1; i++) {
      sToTruncate = strings[i].trim();
      if (sToTruncate.length > 8) {
        sToTruncate = sToTruncate.substring(0, 8);
      } else
        sToTruncate = sToTruncate;
      arrShots.add(sToTruncate);
      print(arrShots[i]);
    }
    arrShots.removeAt(0);
    super.initState();
  }

  //Sends the data to the database if the user decides to save the string

  sendData(String stringName, int totalShots, double totalTime) async {
    print(stringName);
    print(totalShots);
    print(totalTime);
    String sArray = arrShots.join(',');
    String sTotalTime = arrShots[arrShots.length - 1].toString();
    print("Total Time Test: " + sTotalTime);
    print("Comma seperated string " + sArray);
    print("Before Try");
    try {
      var url = 'https://www.topshottimer.co.za/insertTimes.php';
      await post(Uri.parse(url), headers: {
        "Accept": "application/jason"
      }, body: {
        "stringName": stringName,
        "userID": userGetID.toString(),
        "totalShots": arrShots.length.toString(),
        "totalTime": sTotalTime,
        "arrShots": sArray,
      });
      //print("account created");
    } catch (error) {
      print(error.toString());
    }
    print("After Try");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Container(
        child: Column(children: <Widget>[
          Flexible(
            child: new ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: arrShots.length,
              itemBuilder: (BuildContext context, int index) {
                String sShot = arrShots[index];

                return Container(
                    child: Column(
                  children: <Widget>[
                    Card(
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: <Widget>[
                          Text(
                            (index + 1).toString(),
                            style: TextStyle(fontSize: 30),
                          ),
                          Spacer(),
                          Text(sShot, style: TextStyle(fontSize: 30)),
                          Spacer(),
                          SizedBox(
                              height: 35,
                              child: ElevatedButton(

                                child: Text(
                                  "X",
                                  style: TextStyle(
                                      fontSize: 20, color: Color(0xFFDE561C)),
                                ),
                                onPressed: () {
                                  if (arrShots.length > 1) {
                                    arrShots.remove(sShot);
                                  } else
                                    Navigator.pop(context);

                                  print("Hello World");
                                },

                                style: ElevatedButton.styleFrom(
                                    primary: Themes.darkBackgroundColor,
                                  shape: CircleBorder(
                                      side: BorderSide(
                                          color: Color(0xFFDE561C), width: 2)),),
                              )),
                          // FlatButton(
                          //   //color: Colors.red,
                          //   height: 35,
                          //   minWidth: 35,
                          //   shape: CircleBorder(
                          //       side: BorderSide(
                          //           color: Color(0xFFDE561C), width: 2)),
                          //   child: Text(
                          //     "X",
                          //     style: TextStyle(
                          //         fontSize: 20, color: Color(0xFFDE561C)),
                          //   ),
                          //   onPressed: () {
                          //     setState(() {
                          //       if (arrShots.length > 1) {
                          //         arrShots.remove(sShot);
                          //       } else
                          //         Navigator.pop(context);
                          //
                          //       print("Hello World");
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ],
                ));
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
          ),
          Text(
            "Total Time: " + arrShots[arrShots.length - 1],
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "Total Shots: " + (arrShots.length).toString(),
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          //Text("Date: "),

          Container(
            padding: EdgeInsets.only(top: 10, bottom: 0, left: 0, right: 0),
          ),
          Row(
            children: [
              Spacer(),

              SizedBox(
                  width: 160,
                  height: 50,
                  child: ElevatedButton(
                    child: Text(
                      'Close String',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontFamily: 'Montserrat-Regular',
                        letterSpacing: 0.2,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF2C5D63),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  )),

              Spacer(),
              SizedBox(
                  //minwidth: 100,
                  height: 50,
                  width: 160,
                  child: Obx(() => ElevatedButton(
                        onPressed: controller.btnState.value
                            ? () => stringNameDialog()
                            : null,
                        child: Text(
                          'Save String',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Themes.darkButton2Color,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ))),
              Spacer(),
            ],
          ),
          Container(
            padding: EdgeInsets.only(top: 20, bottom: 0, left: 0, right: 0),
            //child: Text('TopShot Timer', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600, ))
          ),
        ]),
      ),
    );
    //
  }

  //Dialog to enter a string name and save the string to the users account
  stringNameDialog() {
    final _stringName = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    bool paidMember = false;


    Dialog dialog = new Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Themes.darkBackgroundColor,
                //this will affect the height of the dialog
                height: 215,
                child: Padding(
                  //play with top padding to make items fit
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "What should we call this string?",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(

                                //labelText: 'Email',
                                labelText: 'String Name'),
                            controller: _stringName,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return 'String Name is required';
                              }
                              return null;
                            },
                            onSaved: (String value) {
                              _stringName.text = value;
                            },
                          ),
                        ),
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
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                if (!_formKey.currentState.validate()) {
                                  return;
                                }
                                _formKey.currentState.save();
                                paidMember = _controller.hasSubscription.value;
                                if (paidMember == false){
                                  Get.to(() => pricing(), arguments: {'pop': true});
                                }
                                else{print("here is my input from the dialog");
                                print(_stringName.text);
                                sendData(_stringName.text, 10, 10.2);
                                  Navigator.pushReplacementNamed(
                                      context, '/PageSelector');
                                }

                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10)),
                                  color: Themes.darkButton2Color,
                                ),
                                height: 45,
                                child: Center(
                                  child: Text("Save",
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
            ),
            Positioned(
                top: -40,
                child: CircleAvatar(
                  backgroundColor: Themes.darkButton2Color,
                  radius: 40,
                  child: Icon(
                    Icons.add,
                    color: Themes.darkBackgroundColor,
                    size: 50,
                  ),
                )),
          ],
        ));
    showDialog(context: context, builder: (context) => dialog);
  }
}

//Get user ID from user preferences
obtainUserDefaults() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userIdDefault = await prefs.get('id');
  userGetID = userIdDefault;
}
